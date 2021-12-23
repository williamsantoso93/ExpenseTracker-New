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
    
    init(expense: Expense? = nil) {
        self._viewModel = StateObject(wrappedValue: AddExpenseViewModel(expense: expense))
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextFiedForm(title: "Value", promt: "50000", value: $viewModel.valueString)
                    .keyboardType(.numberPad)
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
            .navigationTitle("Add")
            .navigationBarTitleDisplayMode(.inline)
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
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
    }
}

struct AddExpenseScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseScreen()
    }
}

struct TextFiedForm: View {
    var title: String
    var promt: String = ""
    @Binding var value: String
    
    var body: some View {
        HStack {
            Text(title)
            TextField(promt, text: $value)
                .multilineTextAlignment(.trailing)
        }
    }
}
