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
    @Published var isLoading = false
    
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
    
    @Published var saveTitle = "Save"
    var isUpdate: Bool = false
    
    init(income: Income? = nil) {
        if let income = income {
            self.income = income
            note = income.note ?? ""
            if let value = income.value {
                valueString = value.splitDigit()
            }
            selectedType = income.type ?? ""
            date = Date()
            
            isUpdate = false
            saveTitle = "Update"
        } else {
            self.income = Income(
                blockID: "",
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
            
            self.isLoading = true
            if self.isUpdate {
                Networking.shared.updateIncome(self.income) { isSuccess in
                    self.isLoading = false
                    return completion(isSuccess)
                }
            } else {
                Networking.shared.postIncome(self.income) { isSuccess in
                    self.isLoading = false
                    return completion(isSuccess)
                }
            }
        }
    }
}
