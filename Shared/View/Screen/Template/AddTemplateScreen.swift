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
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextFiedForm(title: "Name", prompt: "Netflix", value: $viewModel.name)
                    NumberTextFiedForm(title: "Value", prompt: "50000", value: $viewModel.valueString)
#if os(iOS)
                        .keyboardType(.numberPad)
#endif
                    Picker("Type", selection: $viewModel.selectedType) {
                        ForEach(viewModel.expenseType, id: \.self) {
                            Text($0)
                        }
                    }
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
                }
            }
            .loadingView(viewModel.isLoading)
            .showErrorAlert(isShowErrorMessageAlert: $viewModel.isShowErrorMessage, errorMessage: viewModel.errorMessage)
            .navigationTitle("Add")
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
        }
    }
}

struct AddtemplateModelscreen_Previews: PreviewProvider {
    static var previews: some View {
        AddTemplatescreen() {}
    }
}
