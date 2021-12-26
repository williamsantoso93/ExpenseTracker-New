//
//  AddIncomeViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 25/12/21.
//

import Foundation

class AddIncomeViewModel: ObservableObject {
    @Published var income: Income
    @Published var types = GlobalData.shared.types
    
    var incomeType: [String] {
        types.incomeTypes.map { result in
            result.name
        }
    }
    
    
    @Published var valueString = ""
    var value: Int {
        valueString.toInt()
    }
    @Published var selectedType = ""
    @Published var note = ""
    @Published var date = Date()
    
    init(income: Income? = nil) {
        if let income = income {
            self.income = income
            note = income.note ?? ""
            if let value = income.value {
                valueString = String(value)
            }
            selectedType = income.type ?? ""
            date = Date()
        } else {
            self.income = Income(
                id: UUID().uuidString,
                yearMonth: "",
                value: 0,
                type: "",
                note: ""
            )
        }
    }
    
    func save(completion: @escaping (_ isSuccess: Bool) -> Void) {
        income.note = note
        income.value = value
        income.type = selectedType
        income.date = date
        
        YearMonthCheck.shared.getYearMonthID(date) { id in
            self.income.yearMonthID = id
            Networking.shared.postIncome(self.income) { isSuccess in
                return completion(isSuccess)
            }
        }
    }
}
