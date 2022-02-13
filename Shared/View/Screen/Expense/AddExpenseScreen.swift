//
//  AddExpenseScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import SwiftUI

struct AddExpenseScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var globalData = GlobalData.shared
    @StateObject var viewModel: AddExpenseViewModel
    var refesh: () -> Void
    
    @State private var isShowTypeAddScreen = false
    @State private var isShowTemplateAddScreen = false
    
    init(expense: Expense? = nil, refesh: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: AddExpenseViewModel(expense: expense))
        self.refesh = refesh
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NumberTextFiedForm(title: "Value", prompt: "50000".splitDigitDouble(), value: $viewModel.valueString)
#if os(iOS)
                        .keyboardType(.numberPad)
#endif
                    
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
                    
                    Picker("Store", selection: $viewModel.selectedStore) {
                        ForEach(viewModel.storeType, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    if viewModel.isOtherStore {
                        TextField("Indomaret", text: $viewModel.otherStore)
                    }
                    
                    VStack(alignment: .leading, spacing: 2.0) {
                        Text("Note")
                        TextEditor(text: $viewModel.note)
                            .frame(height: 150.0)
                    }
                }
                
                if !viewModel.isUpdate {
                    Section {
                        Toggle("Need Installment", isOn: $viewModel.isInstallment)
                        
                        if viewModel.isInstallment {
                            Picker("Months", selection: $viewModel.installmentMonthString) {
                                let months = ["3", "6", "9", "12", "15", "18", "21", "24", "36"]
                                ForEach(months, id: \.self) {
                                    Text($0)
                                }
                            }
                            NumberTextFiedForm(title: "Interest (%)", prompt: (5/10).splitDigit(), value: $viewModel.interestPercentageString)
                            
                            if viewModel.perMonthExpense > 0 {
                                TextFiedForm(title: "Per Month", value: .constant(viewModel.perMonthExpenseWithInterest.splitDigit()))
                                    .disabled(true)
                                
                                if viewModel.interest > 0 {
                                    VStack(alignment: .leading) {
                                        Text("Monthly Interest : \(viewModel.monthlyInterest.splitDigit())")
                                        Text("Total Intallment : \(viewModel.totalInstallment.splitDigit())\n")
                                        Text("Total Interest : \(viewModel.totalInterest.splitDigit())")
                                    }
                                }
                            }
                        }
                    } header: {
                        Text("Installment")
                    }
                    
                    templateSection
                } else {
                    templateSection
                    
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
            .navigationTitle("Add Expsense")
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
                    globalData.getTypes {
                        viewModel.types = GlobalData.shared.types
                    }
                }
            }
            .sheet(isPresented: $isShowTemplateAddScreen) {
            } content: {
                AddTemplatescreen() {
                    globalData.getTemplateModel(done:  {
                        viewModel.templateModels = GlobalData.shared.templateModels
                    })
                }
            }
        }
    }
    
    var templateSection: some View {
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
            
            Button {
                isShowTypeAddScreen.toggle()
            } label: {
                Text("Add Type")
            }
            
            Button {
                isShowTemplateAddScreen.toggle()
            } label: {
                Text("Add Template")
            }
        } header: {
            Text("Template")
        }
    }
}

struct AddExpenseScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseScreen() {}
    }
}
