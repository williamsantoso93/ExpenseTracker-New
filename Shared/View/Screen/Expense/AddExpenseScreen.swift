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
    var dismiss: (Expense?, DismissType) -> Void
    
    @State private var isShowTypeAddScreen = false
    @State private var isShowDiscardAlert = false
    
    init(expense: Expense? = nil, dismiss: @escaping (Expense?, DismissType) -> Void) {
        self._viewModel = StateObject(wrappedValue: AddExpenseViewModel(expense: expense))
        self.dismiss = dismiss
    }
    
    var body: some View {
        NavigationView {
            Form {
                if !viewModel.isUpdate {
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
                    } header: {
                        Text("Template")
                    }
                }

                Section {
                    NumberTextFiedForm(title: "Value", prompt: "50000".splitDigitDouble(), value: $viewModel.valueString)
#if os(iOS)
                        .keyboardType(.numberPad)
#endif
                    Group {
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
                        
                        Picker("Payment", selection: $viewModel.selectedPayment) {
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
                    }
                    
                    if viewModel.isOtherStore {
                        TextField("Indomaret", text: $viewModel.otherStore)
                    }
                    
                    VStack(alignment: .leading, spacing: 8.0) {
                        Text("Note")
                        TextField("", text: $viewModel.note)
                    }
                    .padding(.bottom, 4)
                }
                
                Section {
                    Toggle("Is Done Export", isOn: $viewModel.isDoneExport)
                    
                    Button("Share Expense") {
                        viewModel.shareExpense { expense in
                            let activityVC = UIActivityViewController(activityItems: [expense], applicationActivities: nil)
                            
                            activityVC.excludedActivityTypes = [
                                .airDrop,
                                .addToReadingList,
                                .postToFlickr,
                                .postToVimeo,
                                .openInIBooks,
                                .print,
                                .assignToContact,
                                .saveToCameraRoll,
                            ]
                            
                            UIApplication.shared.keyWindowPresentedController?.present(activityVC, animated: true) {
                                self.viewModel.copyNote()
                            }
                        }
                    }
                    
                    Button("Copy Note") {
                        viewModel.copyNote()
                    }
                } header: {
                    Text("Copy/Export")
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
                                VStack(alignment: .leading) {
                                    if !viewModel.note.isEmpty {
                                        Text(viewModel.instalmentNote)
                                    }
                                    
                                    TextFiedForm(title: "Per Month", value: .constant(viewModel.perMonthExpenseWithInterest.splitDigit()))
                                        .disabled(true)
                                }
                                
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
                    
                    addSection
                } else {
                    addSection
                    
                    Section {
                        Button("Delete", role: .destructive) {
                            viewModel.delete { isSuccess in
                                if isSuccess {
                                    dismiss(nil, .refreshAll)
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
            .navigationTitle("Add Expense")
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
                        viewModel.save { isSuccess, expense, dismissType in
                            if isSuccess {
                                dismiss(expense, dismissType)
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
                    globalData.getTypes()
                }
            }
            .sheet(isPresented: $viewModel.isShowTemplateAddScreen) {
            } content: {
                AddTemplatescreen(templateModel: viewModel.templateModel) {
                    globalData.getTemplateModel()
                }
            }
        }
    }
    
    var addSection: some View {
        Section {
            Button {
                isShowTypeAddScreen.toggle()
            } label: {
                Text("Add Type")
            }
            
            Button {
                viewModel.addTemplate()
            } label: {
                Text("Add Template")
            }
        } header: {
            Text("Add")
        }
    }
}

struct AddExpenseScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseScreen() {_,_ in }
    }
}
