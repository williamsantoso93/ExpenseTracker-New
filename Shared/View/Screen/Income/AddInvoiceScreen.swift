//
//  AddInvoiceScreen.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 25/12/21.
//

import SwiftUI

struct AddInvoiceScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AddIncomeViewModel
    var refesh: () -> Void
    
    init(income: Income? = nil, refesh: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: AddIncomeViewModel(income: income))
        self.refesh = refesh
    }
    
    var body: some View {
        NavigationView {
            Form {
                NumberTextFiedForm(title: "Value", prompt: "50000", value: $viewModel.valueString)
                    .keyboardType(.numberPad)
                Picker("Type", selection: $viewModel.selectedType) {
                    ForEach(viewModel.incomeType, id: \.self) {
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

struct AddInvoiceScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddInvoiceScreen() {}
    }
}
