//
//  AddTypeScreen.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 25/12/21.
//

import SwiftUI

struct AddTypeScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AddTypeViewModel
    var refesh: () -> Void
        
    @State private var isShowDiscardAlert = false
    
    init(typeModel: TypeModel? = nil, refesh: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: AddTypeViewModel(typeModel: typeModel))
        self.refesh = refesh
    }
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Type", selection: $viewModel.selectedType) {
                    ForEach(viewModel.typesCategory, id: \.self) {
                        Text($0)
                    }
                }
                TextFiedForm(title: "Name", prompt: "IPL", value: $viewModel.name)
                
                MultiPickerFormView("Subcategory of", items: viewModel.subcategoriesOf, selectedItems: $viewModel.selectedSubcategoryOf)
                    .disabled(viewModel.isSubCategoryDisabled)
                
                Picker("Nature", selection: $viewModel.selectedNature) {
                    ForEach(viewModel.natures, id: \.self) {
                        Text($0)
                    }
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
            .loadingView(viewModel.isLoading)
            .showErrorAlert(isShowErrorMessageAlert: $viewModel.isShowErrorMessage, errorMessage: viewModel.errorMessage)
            .networkErrorAlert()
            .discardChangesAlert(isShowAlert: $isShowDiscardAlert) {
                presentationMode.wrappedValue.dismiss()
            }
            .navigationTitle("Add Type")
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

struct AddTypeScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddTypeScreen() {}
    }
}
