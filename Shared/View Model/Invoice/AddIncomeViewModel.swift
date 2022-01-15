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
    @Published var templateModels = GlobalData.shared.templateModels.filter { result in
        result.category == "Income"
    }
    @Published var isLoading = false
    
    var incomeType: [String] {
        types.incomeTypes.map { result in
            result.name
        }
    }
    
    
    @Published var valueString = ""
    var value: Double {
        valueString.toDouble() ?? 0
    }
    @Published var selectedType = ""
    @Published var selectedTypes: [String] = []
    @Published var note = ""
    @Published var selectedTemplateIndex = -1
    @Published var date = Date()
    
    var saveTitle: String {
        isUpdate ? "Update" : "Save"
    }
    var isUpdate: Bool = false
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    init(income: Income?) {
        if let income = income {
            self.income = income
            note = income.note ?? ""
            if let value = income.value {
                valueString = value.splitDigit()
            }
            selectedTypes = income.types ?? []
            date = income.date ?? Date()
            
            isUpdate = true
        } else {
            self.income = Income(
                blockID: "",
                id: UUID().uuidString,
                yearMonth: "",
                value: 0,
                types: [],
                note: ""
            )
        }
    }
    
    func delete(completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard !income.blockID.isEmpty else { return }
        
        isLoading = true
        Networking.shared.delete(id: income.blockID) { isSuccess in
            self.isLoading = false
            return completion(isSuccess)
        }
    }
    
    func save(completion: @escaping (_ isSuccess: Bool) -> Void) {
        do {
            income.note = note
            income.value = try Validation.numberTextField(value)
            income.types = try Validation.picker(selectedTypes, typeError: .noType)
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
        if let selectedTypes = selectedTemplateModel.types {
            self.selectedTypes = selectedTypes
        }
        if let valueString = selectedTemplateModel.value {
            self.valueString = valueString.splitDigit()
        }
    }
}
