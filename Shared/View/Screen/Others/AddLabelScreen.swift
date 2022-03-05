//
//  AddLabelScreen.swift
//  ExpenseTracker
//
//  Created by William Santoso on 01/03/22.
//

import SwiftUI

class AddLabelViewModel: ObservableObject {
    let coreDataManager = CoreDataManager.shared
    
    @Published var labelModel: LabelModel
    @Published var selectedLabelModel: LabelModel
    @Published var name = ""
    
    var saveTitle: String {
        isUpdate ? "Update" : "Save"
    }
    var isUpdate: Bool = false
    
    var isChanged: Bool {
        name != selectedLabelModel.name
    }
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    init(labelModel: LabelModel?) {
        if let labelModel = labelModel {
            self.labelModel = labelModel
            selectedLabelModel = labelModel
            
            name = labelModel.name
            
            isUpdate = true
        } else {
            let defaultLabel = LabelModel(name: "")
            self.labelModel = defaultLabel
            selectedLabelModel = defaultLabel
        }
    }
    
    func save(completion: @escaping (_ isSuccess: Bool) -> Void) {
        do {
            labelModel.name = try Validation.textField(name.trimWhitespace())
            
            coreDataManager.createLabel(labelModel)
        } catch let error {
            if let error = error as? ValidationError {
                if let errorMessage = error.errorMessage {
                    self.errorMessage = errorMessage
                    isShowErrorMessage = true
                }
            }
        }
    }
    
    func delete(completion: @escaping (_ isSuccess: Bool) -> Void) {
        coreDataManager.deleteLabel(labelModel)
        completion(true)
    }
}

struct AddLabelScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AddLabelViewModel
    @State private var isShowDiscardAlert = false
    var refesh: () -> Void
    
    init(labelModel: LabelModel? = nil, refesh: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: AddLabelViewModel(labelModel: labelModel))
        self.refesh = refesh
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextFiedForm(title: "Name", prompt: "Home", value: $viewModel.name)
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
            .navigationTitle("Add Label")
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

struct AddLabelScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddLabelScreen(labelModel: nil)
    }
}
