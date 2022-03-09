//
//  AddTemplateCDScreen.swift
//  ExpenseTracker
//
//  Created by William Santoso on 09/03/22.
//

import SwiftUI

struct AddTemplateCDScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AddTemplateCDViewModel
    var refesh: () -> Void
    
    @State private var isShowTypeAddScreen = false
    @State private var isShowDiscardAlert = false
    
    init(templateModelCD: TemplateModelCD? = nil, refesh: @escaping () -> Void = {}) {
        self._viewModel = StateObject(wrappedValue: AddTemplateCDViewModel(templateModelCD: templateModelCD))
        self.refesh = refesh
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Type", selection: $viewModel.selectedType) {
                        ForEach(viewModel.typesCategory, id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                    TextFiedForm(title: "Name", prompt: "Netflix", value: $viewModel.name)
                    NumberTextFiedForm(title: "Value", prompt: "50000".splitDigitDouble(), value: $viewModel.valueString)
#if os(iOS)
                        .keyboardType(.numberPad)
#endif
                    
                    Group {
                        Picker("Label", selection: $viewModel.selectedLabel) {
                            ForEach(viewModel.labels, id: \.self) {
                                Text($0.name)
                            }
                        }
                        Picker("Account", selection: $viewModel.selectedAccount) {
                            ForEach(viewModel.accounts, id: \.self) {
                                Text($0.name)
                            }
                        }
                        Picker("Category", selection: $viewModel.selectedCategory) {
                            ForEach(viewModel.categories, id: \.self) {
                                Text($0.name)
                            }
                        }
                        Picker("Subcategory", selection: $viewModel.selectedSubcategory) {
                            ForEach(viewModel.subcategories, id: \.self) {
                                Text($0.name)
                            }
                        }
                        .disabled(viewModel.isSubCategoryDisabled)
                        
                        Picker("Duration", selection: $viewModel.selectedDuration) {
                            ForEach(viewModel.durations, id: \.self) {
                                Text($0.name)
                            }
                        }
                        
                        if viewModel.selectedType.lowercased() == "expense" {
                            Picker("Payment", selection: $viewModel.selectedPayment) {
                                ForEach(viewModel.payments, id: \.self) {
                                    Text($0.name)
                                }
                            }
                            
                            Picker("Store", selection: $viewModel.selectedStore) {
                                ForEach(viewModel.stores, id: \.self) {
                                    Text($0.name)
                                }
                            }
                            
                            if viewModel.isOtherStore {
                                TextField("Indomaret", text: $viewModel.otherStore)
                            }
                        }
                    }
                }
                
                Section {
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
            }
            .showErrorAlert(isShowErrorMessageAlert: $viewModel.isShowErrorMessage, errorMessage: viewModel.errorMessage)
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
//                .sheet(isPresented: $isShowTypeAddScreen) {
//                } content: {
//                    AddTypeScreen() {
//                        GlobalData.shared.getTypes {
//                            viewModel.types = GlobalData.shared.types
//                        }
//                    }
//                }
            }
        }
    }
}

struct AddTemplateCDScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddTemplateCDScreen()
    }
}
