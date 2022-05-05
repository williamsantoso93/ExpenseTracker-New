//
//  AddTemplatescreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 26/12/21.
//

import SwiftUI

struct AddTemplatescreen: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AddTemplateViewModel
    var refesh: () -> Void
    
    @State private var isShowTypeAddScreen = false
    @State private var isShowDiscardAlert = false
    
    init(templateModel: TemplateModel? = nil, refesh: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: AddTemplateViewModel(templateModel: templateModel))
        self.refesh = refesh
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Type", selection: $viewModel.selectedType) {
                        ForEach(viewModel.typesCategory, id: \.self) {
                            Text($0)
                        }
                    }
                    TextFiedForm(title: "Name", prompt: "Netflix", value: $viewModel.name)
                    NumberTextFiedForm(title: "Value", prompt: "50000".splitDigitDouble(), value: $viewModel.valueString)
#if os(iOS)
                        .keyboardType(.numberPad)
#endif
                    
                    Picker("Label", selection: $viewModel.selectedLabel) {
                        ForEach(viewModel.labels, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Account", selection: $viewModel.selectedAccount) {
                        ForEach(viewModel.accounts, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        ForEach(viewModel.categories, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Subcategory", selection: $viewModel.selectedSubcategory) {
                        ForEach(viewModel.subcategories, id: \.self) {
                            Text($0)
                        }
                    }
                    .disabled(viewModel.isSubCategoryDisabled)
                    
                    Picker("Duration", selection: $viewModel.selectedDuration) {
                        ForEach(viewModel.durationType, id: \.self) {
                            Text($0)
                        }
                    }
                    if viewModel.selectedType == "Expense" {
                        Picker("Payment", selection: $viewModel.selectedPayment) {
                            ForEach(viewModel.paymentType, id: \.self) {
                                Text($0)
                            }
                        }
                        Picker("Store", selection: $viewModel.selectedStore) {
                            ForEach(viewModel.storeType, id: \.self) {
                                Text($0)
                            }
                        }
                        
                        if viewModel.isOtherStore {
                            TextField("Indomaret", text: $viewModel.otherStore)
                        }
                    }
                    Toggle("Is Done Export", isOn: $viewModel.isDoneExport)
                }
                
                Button {
                    isShowTypeAddScreen.toggle()
                } label: {
                    Text("Add Type")
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
            .navigationTitle("Add Template")
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
            .sheet(isPresented: $isShowTypeAddScreen) {
            } content: {
                AddTypeScreen() {
                    GlobalData.shared.getTypes()
                }
            }
        }
    }
}

struct AddtemplateModelscreen_Previews: PreviewProvider {
    static var previews: some View {
        AddTemplatescreen() {}
    }
}
