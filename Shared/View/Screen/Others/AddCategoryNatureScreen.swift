//
//  AddCategoryNatureScreen.swift
//  ExpenseTracker
//
//  Created by William Santoso on 05/03/22.
//

import SwiftUI

class AddCategoryNatureViewModel: AddViewModel {
    let coreDataManager = CoreDataManager.shared
    
    @Published var categoryNature: CategoryNature
    @Published var selectedCategoryNature: CategoryNature
    @Published var name = ""
    @Published var categories: [Category] = []
    
    
    var saveTitle: String {
        isUpdate ? "Update" : "Save"
    }
    var isUpdate: Bool = false
    
    var isChanged: Bool {
        name != selectedCategoryNature.name
    }
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    init(categoryNature: CategoryNature?) {
        if let categoryNature = categoryNature {
            self.categoryNature = categoryNature
            selectedCategoryNature = categoryNature
            
            name = categoryNature.name
            categories = categoryNature.categories
            
            isUpdate = true
        } else {
            let defaultCategoryNature = CategoryNature(
                name: ""
            )
            self.categoryNature = defaultCategoryNature
            selectedCategoryNature = defaultCategoryNature
        }
    }
    
    func save(completion: @escaping (Bool) -> Void) {
        do {
            categoryNature.name = try Validation.textField(name.trimWhitespace())
            categoryNature.categories = categories
            
            if isUpdate {
                coreDataManager.updateCategoryNature(categoryNature)
            } else {
                coreDataManager.createCategoryNature(categoryNature)
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
        coreDataManager.deleteCategoryNature(categoryNature)
        completion(true)
    }
}

struct AddCategoryNatureScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AddCategoryNatureViewModel
    @State private var isShowDiscardAlert = false
    var refesh: () -> Void
    
    init(categoryNature: CategoryNature? = nil, refesh: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: AddCategoryNatureViewModel(categoryNature: categoryNature))
        self.refesh = refesh
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextFiedForm(title: "Name", prompt: "Must", value: $viewModel.name)
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
            .navigationTitle("Add CategoryNature")
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

struct AddCategoryNatureScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryNatureScreen()
    }
}
