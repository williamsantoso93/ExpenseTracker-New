//
//  AddExpenseViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 21/12/21.
//

import Foundation

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
    
    @Published var valueString = ""
    var value: Int {
        valueString.toInt()
    }
    @Published var selectedType = ""
    @Published var selectedPayment = ""
    @Published var selectedDuration = ""
    @Published var selectedTemplateIndex = -1
    @Published var note = ""
    @Published var date = Date()
    
    var saveTitle: String {
        isUpdate ? "Update" : "Save"
    }
    var isUpdate: Bool = false
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    init(expense: Expense? = nil) {
        if let expense = expense {
            self.expense = expense
            note = expense.note ?? ""
            if let value = expense.value {
                valueString = value.splitDigit()
            }
            selectedDuration = expense.duration ?? ""
            selectedPayment = expense.paymentVia ?? ""
            selectedType = expense.type ?? ""
            date = expense.date ?? Date()
            
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
                type: "",
                date: Date()
            )
        }
    }
    
    func save(completion: @escaping (_ isSuccess: Bool) -> Void) {
        do {
            expense.note = note
            expense.value = try Validation.numberTextField(value)
            expense.type = try Validation.picker(selectedType, typeError: .noType)
            expense.paymentVia = try Validation.picker(selectedPayment, typeError: .noPaymentVia)
            expense.duration = try Validation.picker(selectedDuration, typeError: .noDuration)
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
                    Networking.shared.postExpense(self.expense) { isSuccess in
                        self.isLoading = false
                        return completion(isSuccess)
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
}
