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
    var value: Int {
        valueString.toInt()
    }
    @Published var selectedType = ""
    @Published var selectedTypes: [String] = []
    @Published var selectedPayment = ""
    @Published var selectedDuration = ""
    @Published var selectedStore = ""
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
            selectedTypes = expense.types ?? []
            date = expense.date ?? Date()
            
            
            let storeNote = getStoreNote(expense.note)
            if let storeNote = storeNote {
                selectedStore = storeNote.first ?? ""
                note = storeNote.last ?? ""
            } else {
                if let expenseNote = expense.note {
                    if storeType.contains(expenseNote) {
                        selectedStore = expenseNote
                        note = ""
                    } else {
                        note = expenseNote
                    }
                } else {
                    note = ""
                }
            }
            
            isUpdate = true
        } else {
            self.expense = Expense(
                blockID: "",
                id: UUID().uuidString,
                yearMonth: "",
                note: "",
                value: 0,
                duration: "",
                paymentVia: "",
                types: [],
                date: Date()
            )
            selectedDuration = "Once"
        }
    }
    
    let noteSeparator = " | "
    
    func getStoreNote(_ note: String?) -> [String]? {
        guard let note = note else { return nil }
        guard note.contains(noteSeparator) else { return nil }
        let strings = note.components(separatedBy: noteSeparator)
        guard strings.count == 2 else { return nil }
        
        return strings
    }
    
    func delete(completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard !expense.blockID.isEmpty else { return }
        
        isLoading = true
        Networking.shared.delete(id: expense.blockID) { isSuccess in
            self.isLoading = false
            return completion(isSuccess)
        }
    }
    
    func noteStore() -> String{
        var note = note
        if !selectedStore.isEmpty {
            if !note.isEmpty {
                note = selectedStore + noteSeparator + note
            } else {
                note = selectedStore
            }
        }
        
        return note
    }
    
    func save(completion: @escaping (_ isSuccess: Bool) -> Void) {
        do {
            expense.value = try Validation.numberTextField(value)
            expense.types = try Validation.picker(selectedTypes, typeError: .noType)
            expense.paymentVia = try Validation.picker(selectedPayment, typeError: .noPaymentVia)
            expense.duration = try Validation.picker(selectedDuration, typeError: .noDuration)
            expense.note = noteStore()
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
        
        if let name = selectedTemplateModel.name {
            note = name
        }
        if let selectedDuration = selectedTemplateModel.duration {
            self.selectedDuration = selectedDuration
        }
        if let selectedType = selectedTemplateModel.type {
            self.selectedType = selectedType
        }
        if let selectedPayment = selectedTemplateModel.paymentVia {
            self.selectedPayment = selectedPayment
        }
        if let valueString = selectedTemplateModel.value {
            self.valueString = valueString.splitDigit()
        }
    }
    
    //MARK: - Installment
    @Published var isInstallment = false
    @Published var installmentMonthString = "3"
    @Published var interestPercentageString = "0"
    
    var installmentMonth: Int {
        Int(installmentMonthString) ?? 0
    }
    var perMonthExpense: Int {
        installmentMonth > 0 ? value / installmentMonth : 0
    }
    var interest: Double {
        let interestPercentageDouble = Double(interestPercentageString) ?? 0
        return interestPercentageDouble / 100
    }
    var monthlyInterest: Int {
        Int(Double(value) * interest)
    }
    var perMonthExpenseWithInterest: Int {
        if installmentMonth > 0 && value > 0 {
            return perMonthExpense + Int(monthlyInterest)
        }
        return perMonthExpense
    }
    var totalInstallment: Int {
        perMonthExpenseWithInterest * installmentMonth
    }
    var totalInterest: Int {
        totalInstallment - value
    }
    
    func saveInstallment(completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard installmentMonth > 0 else { return }
        var count = 0
        var expense = self.expense
        expense.value = perMonthExpenseWithInterest
        for installment in 1 ... installmentMonth {
            if installment > 1 {
                expense.date = self.expense.date?.addMonth(by: installment)
            }
            expense.note = note + " | Installment \(installment) to \(installmentMonth)"
            guard let date = expense.date else { return }
            YearMonthCheck.shared.getYearMonthID(date) { id in
                expense.yearMonthID = id
                
                Networking.shared.postExpense(expense) { isSuccess in
                    count += 1
                    
                    if count >= self.installmentMonth {
                        return completion(isSuccess)
                    }
                }
            }
        }
    }
}
