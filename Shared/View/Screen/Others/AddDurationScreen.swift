//
//  AddDurationScreen.swift
//  ExpenseTracker
//
//  Created by William Santoso on 05/03/22.
//

import SwiftUI

class AddDurationViewModel: AddViewModel {
    let coreDataManager = CoreDataManager.shared
    
    @Published var duration: Duration
    @Published var selectedDuration: Duration
    @Published var name = ""
    
    
    var saveTitle: String {
        isUpdate ? "Update" : "Save"
    }
    var isUpdate: Bool = false
    
    var isChanged: Bool {
        name != selectedDuration.name
    }
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    init(duration: Duration?) {
        if let duration = duration {
            self.duration = duration
            selectedDuration = duration
            
            name = duration.name
            
            isUpdate = true
        } else {
            let defaultDuration = Duration(name: "")
            self.duration = defaultDuration
            selectedDuration = defaultDuration
        }
    }
    
    func save(completion: @escaping (Bool) -> Void) {
        do {
            duration.name = try Validation.textField(name.trimWhitespace())
            
            if isUpdate {
                coreDataManager.updateDuration(duration)
            } else {
                coreDataManager.createDuration(duration)
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
        coreDataManager.deleteDuration(duration)
        completion(true)
    }
}

struct AddDurationScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AddDurationViewModel
    @State private var isShowDiscardAlert = false
    var refesh: () -> Void
    
    init(duration: Duration? = nil, refesh: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: AddDurationViewModel(duration: duration))
        self.refesh = refesh
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextFiedForm(title: "Name", prompt: "Monthly", value: $viewModel.name)
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
            .navigationTitle("Add Duration")
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

struct AddDurationScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddDurationScreen()
    }
}
