//
//  AddExpenseCDScreen.swift
//  ExpenseTracker
//
//  Created by William Santoso on 05/03/22.
//

import SwiftUI

struct AddExpenseCDScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var globalData = GlobalData.shared
    @StateObject var viewModel: AddExpenseCDViewModel
    var refesh: () -> Void
    
    @State private var isShowTypeAddScreen = false
    @State private var isShowDiscardAlert = false
    
    init(expenseCD: ExpenseCD? = nil, refesh: @escaping () -> Void = {}) {
        self._viewModel = StateObject(wrappedValue: AddExpenseCDViewModel(expenseCD: expenseCD))
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
                        
                        Picker("Payment", selection: $viewModel.selectedPayment) {
                            ForEach(viewModel.payments, id: \.self) {
                                Text($0.name)
                            }
                        }
                        
                        Picker("Duration", selection: $viewModel.selectedDuration) {
                            ForEach(viewModel.durations, id: \.self) {
                                Text($0.name)
                            }
                        }
                        
                        DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                        
                        Picker("Store", selection: $viewModel.selectedStore) {
                            ForEach(viewModel.stores, id: \.self) {
                                Text($0.name)
                            }
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
                                
                                if let installmentDates = viewModel.installmentDates {
                                    Text(installmentDates)
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
//            .loadingView(viewModel.isLoading)
            .showErrorAlert(isShowErrorMessageAlert: $viewModel.isShowErrorMessage, errorMessage: viewModel.errorMessage)
            .networkErrorAlert()
            .discardChangesAlert(isShowAlert: $isShowDiscardAlert) {
                presentationMode.wrappedValue.dismiss()
            }
            .navigationTitle("Add Expsense")
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
//            .sheet(isPresented: $isShowTypeAddScreen) {
//            } content: {
//                AddTypeScreen() {
//                    globalData.getTypes {
//                        viewModel.types = GlobalData.shared.types
//                    }
//                }
//            }
//            .sheet(isPresented: $viewModel.isShowTemplateAddScreen) {
//            } content: {
//                AddTemplatescreen(templateModel: viewModel.templateModel) {
//                    globalData.getTemplateModel(done:  {
//                        viewModel.templateModels = GlobalData.shared.templateModels
//                    })
//                }
//            }
        }
    }
    
    var templateSection: some View {
        Section {
//            Picker("Template", selection: $viewModel.selectedTemplateIndex) {
//                ForEach(viewModel.templateModels.indices, id: \.self) { index in
//                    let templateModel = viewModel.templateModels[index]
//                    Text(templateModel.name ?? "")
//                        .tag(index)
//                }
//            }
//            .onChange(of: viewModel.selectedTemplateIndex) { index in
//                viewModel.applyTemplate(at: index)
//            }
//
//            Button {
//                isShowTypeAddScreen.toggle()
//            } label: {
//                Text("Add Type")
//            }
            
            Button {
//                viewModel.addTemplate()
            } label: {
                Text("Add Template")
            }
        } header: {
            Text("Template")
        }
    }
}

struct AddExpenseCDScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseCDScreen()
    }
}
