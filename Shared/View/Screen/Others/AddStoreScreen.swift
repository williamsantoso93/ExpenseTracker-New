//
//  AddStoreScreen.swift
//  ExpenseTracker
//
//  Created by William Santoso on 05/03/22.
//

import SwiftUI

class AddStoreViewModel: AddViewModel {
    let coreDataManager = CoreDataManager.shared
    
    @Published var store: Store
    @Published var selectedStore: Store
    @Published var name = ""
    @Published var isHaveMultipleStore: Bool = false
    
    
    var saveTitle: String {
        isUpdate ? "Update" : "Save"
    }
    var isUpdate: Bool = false
    
    var isChanged: Bool {
        name != selectedStore.name ||
        (isHaveMultipleStore != store.isHaveMultipleStore)
    }
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    init(store: Store?) {
        if let store = store {
            self.store = store
            selectedStore = store
            
            name = store.name
            isHaveMultipleStore = store.isHaveMultipleStore
            
            isUpdate = true
        } else {
            let defaultStore = Store(
                isHaveMultipleStore: false,
                name: ""
            )
            self.store = defaultStore
            selectedStore = defaultStore
        }
    }
    
    func save(completion: @escaping (Bool) -> Void) {
        do {
            store.name = try Validation.textField(name.trimWhitespace())
            store.isHaveMultipleStore = isHaveMultipleStore
            
            if isUpdate {
                coreDataManager.updateStore(store)
            } else {
                coreDataManager.createStore(store)
            }
            completion(true)
        } catch let error {
            if let error = error as? ValidationError {
                if let errorMessage = error.errorMessage {
                    self.errorMessage = errorMessage
                    isShowErrorMessage = true
                }
            }
        }
    }
    
    func delete(completion: @escaping (Bool) -> Void) {
        coreDataManager.deleteStore(store)
        completion(true)
    }
}

struct AddStoreScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AddStoreViewModel
    @State private var isShowDiscardAlert = false
    var refesh: () -> Void
    
    init(store: Store? = nil, refesh: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: AddStoreViewModel(store: store))
        self.refesh = refesh
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextFiedForm(title: "Name", prompt: "Indomaret", value: $viewModel.name)
                    Toggle("Is Multiple Store", isOn: $viewModel.isHaveMultipleStore)
                }
                
                if viewModel.isUpdate {
                    Section {
                        Button("Delete", role: .destructive) {
                            viewModel.delete { isSuccess in
                                if isSuccess {
                                    refesh()
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    }
                }
            }
            .showErrorAlert(isShowErrorMessageAlert: $viewModel.isShowErrorMessage, errorMessage: viewModel.errorMessage)
            .discardChangesAlert(isShowAlert: $isShowDiscardAlert) {
                presentationMode.wrappedValue.dismiss()
            }
            .navigationTitle("Add Store")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if viewModel.isChanged {
                            isShowDiscardAlert.toggle()
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text(viewModel.isChanged ? "Discard" : "Cancel")
                    }
                }
#endif
                ToolbarItem {
                    Button {
                        viewModel.save { isSuccess in
                            if isSuccess {
                                refesh()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } label: {
                        Text(viewModel.saveTitle)
                    }
                    .disabled(!viewModel.isChanged)
                }
            }
        }
    }
}

struct AddStoreScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddStoreScreen()
    }
}
