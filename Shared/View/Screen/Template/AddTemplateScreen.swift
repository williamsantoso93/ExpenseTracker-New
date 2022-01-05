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
    
    init(templateModel: TemplateModel? = nil, refesh: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: AddTemplateViewModel(templateModel: templateModel))
        self.refesh = refesh
    }
    
    @State private var isShowTypeAddScreen = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextFiedForm(title: "Name", prompt: "Netflix", value: $viewModel.name)
                    NumberTextFiedForm(title: "Value", prompt: "50000", value: $viewModel.valueString)
#if os(iOS)
                        .keyboardType(.numberPad)
#endif
                    MultiPickerFormView("Type(s)", items: viewModel.expenseType, selectedItems: $viewModel.selectedTypes)
                    
                    Picker("Payment Via", selection: $viewModel.selectedPayment) {
                        ForEach(viewModel.paymentType, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Duration", selection: $viewModel.selectedDuration) {
                        ForEach(viewModel.durationType, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        ForEach(viewModel.category, id: \.self) {
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
            .navigationTitle("Add Template")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
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
                }
            }
            .sheet(isPresented: $isShowTypeAddScreen) {
            } content: {
                AddTypeScreen() {
                    GlobalData.shared.getTypes {
                        viewModel.types = GlobalData.shared.types
                    }
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
