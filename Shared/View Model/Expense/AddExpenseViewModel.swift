//
//  AddExpenseViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 21/12/21.
//

import Foundation
import SwiftUI

class AddExpenseViewModel: ObservableObject {
    @Published var expense: Expense
    @Published var types = GlobalData.shared.types
    @Published var templateModels = GlobalData.shared.templateModels.filter { result in
        result.category == "Expense"
    }
    @Published var isLoading = false
    
    var expenseType: [String] {
        types.expenseTypes.map { result in
            result.name
        }
    }
    var paymentType: [String] {
        types.paymentTypes.map { result in
            result.name
        }
    }
    var durationType: [String] {
        types.durationTypes.map { result in
            result.name
        }
    }
    var storeType: [String] {
        types.storeTypes.map { result in
            result.name
        }
    }
    
    @Published var valueString = ""
    var value: Double {
        valueString.toDouble() ?? 0
    }
    
    @Published var selectedCategory = ""
    @Published var selectedPayment = ""
    @Published var selectedDuration = ""
    @Published var selectedStore = "Other"
    var isOtherStore: Bool {
        selectedStore == "Other"
    }
    @Published var otherStore = ""
    @Published var selectedTemplateIndex = -1
    @Published var note = ""
    @Published var date = Date()
    
    var saveTitle: String {
        isUpdate ? "Update" : "Save"
    }
    var isUpdate: Bool = false
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    init(expense: Expense?) {
        if let expense = expense {
            self.expense = expense
            if let value = expense.value {
                valueString = value.splitDigit()
            }
            selectedDuration = expense.duration ?? ""
            selectedPayment = expense.paymentVia ?? ""
            selectedCategory = expense.category ?? ""
            date = expense.date ?? Date()
            
            checkStore(expense.store)
            note = expense.note ?? ""
            
            isUpdate = true
        } else {
            self.expense = Expense(
                blockID: "",
                id: UUID().uuidString,
                yearMonth: "",
                note: "",
                value: 0,
                account: "",
                category: "",
                subcategory: "",
                duration: "",
                paymentVia: "",
                store: "",
                date: Date()
            )
            selectedDuration = "Once"
        }
    }
    
    let noteSeparator = " | "
    
    func checkStore(_ store: String?) {
        selectedStore = store ?? "Other"
        if let store = store {
            if !storeType.contains(store) && !store.isEmpty {
                otherStore = store
                selectedStore = "Other"
            }
        }
    }
    
    func delete(completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard !expense.blockID.isEmpty else { return }
        
        isLoading = true
        Networking.shared.delete(id: expense.blockID) { isSuccess in
            self.isLoading = false
            return completion(isSuccess)
        }
    }
    
    func getStore() -> String {
        if isOtherStore {
            return otherStore
        } else {
            return selectedStore
        }
    }
    
    func save(completion: @escaping (_ isSuccess: Bool) -> Void) {
        do {
            expense.value = try Validation.numberTextField(value)
            expense.category = try Validation.picker(selectedCategory, typeError: .noType)
            expense.paymentVia = try Validation.picker(selectedPayment, typeError: .noPaymentVia)
            expense.duration = try Validation.picker(selectedDuration, typeError: .noDuration)
            expense.store = getStore()
            expense.note = note
            expense.date = date
            
            YearMonthCheck.shared.getYearMonthID(date) { id in
                self.expense.yearMonthID = id
                
                self.isLoading = true
                if self.isUpdate {
                    Networking.shared.updateExpense(self.expense) { isSuccess in
                        self.isLoading = false
                        return completion(isSuccess)
                    }
                } else {
                    if self.isInstallment && (self.installmentMonth > 0) {
                        self.saveInstallment { isSuccess in
                            self.isLoading = false
                            return completion(isSuccess)
                        }
                    } else {
                        Networking.shared.postExpense(self.expense) { isSuccess in
                            self.isLoading = false
                            return completion(isSuccess)
                        }
                    }
                }
            }
        } catch let error {
            if let error = error as? ValidationError {
                if let errorMessage = error.errorMessage {
                    self.errorMessage = errorMessage
                    isShowErrorMessage = true
                }
            }
        }
    }
    
    func applyTemplate(at index: Int) {
        guard index >= 0 else {
            return
        }
        let selectedTemplateModel = templateModels[index]
        if let selectedDuration = selectedTemplateModel.duration {
            self.selectedDuration = selectedDuration
        }
        if let selectedCategory = selectedTemplateModel.category {
            self.selectedCategory = selectedCategory
        }
        if let selectedPayment = selectedTemplateModel.paymentVia {
            self.selectedPayment = selectedPayment
        }
        if let valueString = selectedTemplateModel.value {
            self.valueString = valueString.splitDigit()
        }
        if let selectedStore = selectedTemplateModel.store {
            checkStore(selectedStore)
        }
        if let name = selectedTemplateModel.name {
            if name != getStore() {
                note = name
            }
        }
    }
    
    //MARK: - Installment
    @Published var isInstallment = false
    @Published var installmentMonthString = "3"
    @Published var interestPercentageString = "0"
    
    var installmentMonth: Int {
        Int(installmentMonthString) ?? 0
    }
    var perMonthExpense: Double {
        installmentMonth > 0 ? value / Double(installmentMonth) : 0
    }
    var interest: Double {
        let interestPercentageDouble = interestPercentageString.toDouble() ?? 0
        return interestPercentageDouble / 100
    }
    var monthlyInterest: Double {
        value * interest
    }
    var perMonthExpenseWithInterest: Double {
        if installmentMonth > 0 && value > 0 {
            return perMonthExpense + monthlyInterest
        }
        return perMonthExpense
    }
    var totalInstallment: Double {
        perMonthExpenseWithInterest * Double(installmentMonth)
    }
    var totalInterest: Double {
        totalInstallment - value
    }
    
    func saveInstallment(completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard installmentMonth > 0 else { return }
        var count = 0
        var expense = self.expense
        expense.category?.append("Installment")
        expense.duration = "Monthly"
        let strValue = String(format: "%.2f", perMonthExpenseWithInterest)
        expense.value = Double(strValue) ?? 0
        
        for installment in 1 ... installmentMonth {
            if installment > 1 {
                expense.date = expense.date?.addMonth(by: 1)
            }
            expense.note = note + " | Installment \(installment) to \(installmentMonth)"
            guard let date = expense.date else { return }
            YearMonthCheck.shared.getYearMonthID(date) { id in
                expense.yearMonthID = id
                
                Networking.shared.postExpense(expense) { isSuccess in
                    count += 1

                    if count >= self.installmentMonth {
                        self.isLoading = false
                        return completion(true)
                    }
                }
            }
        }
    }
}
