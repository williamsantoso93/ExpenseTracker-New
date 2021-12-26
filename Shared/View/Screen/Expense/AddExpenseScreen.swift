//
//  AddExpenseScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import SwiftUI

struct AddExpenseScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AddExpenseViewModel
    var refesh: () -> Void
    
    init(expense: Expense? = nil, refesh: @escaping () -> Void) {
        print(expense)
        self._viewModel = StateObject(wrappedValue: AddExpenseViewModel(expense: expense))
        self.refesh = refesh
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NumberTextFiedForm(title: "Value", prompt: "50000".splitDigit(), value: $viewModel.valueString)
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
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                    VStack(alignment: .leading, spacing: 2.0) {
                        Text("Note")
                        TextEditor(text: $viewModel.note)
                            .frame(height: 150.0)
                    }
                }

                Section {
                    Picker("Template", selection: $viewModel.selectedTemplateIndex) {
                        ForEach(viewModel.templateModels.indices, id: \.self) { index in
                            let templateModel = viewModel.templateModels[index]
                            Text(templateModel.name ?? "")
                                .tag(index)
                        }
                    }
                    .onChange(of: viewModel.selectedTemplateIndex) { index in
                        viewModel.applyTemplate(at: index)
                    }
                }
            }
            .loadingView(viewModel.isLoading)
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

struct AddExpenseScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseScreen() {}
    }
}
