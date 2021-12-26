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
                Section {
                    NumberTextFiedForm(title: "Value", prompt: "50000".splitDigit(), value: $viewModel.valueString)
#if os(iOS)
                        .keyboardType(.numberPad)
#endif
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
                
                Section {
                    Picker("Template", selection: $viewModel.selectedTemplateIndex) {
                        ForEach(viewModel.templates.indices, id: \.self) { index in
                            let templateExpense = viewModel.templates[index]
                            Text(templateExpense.name ?? "")
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

struct AddInvoiceScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddInvoiceScreen() {}
    }
}
