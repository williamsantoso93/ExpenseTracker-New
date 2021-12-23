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
        Int(valueString) ?? 0
    }
    @Published var selectedType = ""
    @Published var selectedPayment = ""
    @Published var selectedDuration = ""
    @Published var note = ""
    @Published var date = Date()
    
    
    init(expense: Expense? = nil) {
        if let expense = expense {
            self.expense = expense
            note = expense.note ?? ""
            if let value = expense.value {
                valueString = String(value)
            }
            selectedDuration = expense.duration ?? ""
            selectedPayment = expense.paymentVia ?? ""
            selectedType = expense.type ?? ""
            date = expense.date ?? Date()
        } else {
            self.expense = Expense(
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
        expense.yearMonthID = GlobalData.shared.getYearMonthID(date)
        expense.note = note
        expense.value = value
        expense.duration = selectedDuration
        expense.paymentVia = selectedPayment
        expense.type = selectedType
        expense.date = date
        Networking.shared.postExpense(expense) { isSuccess in
            return completion(isSuccess)
        }
    }
}
