//
//  AddIncomeViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 25/12/21.
//

import Foundation
import SwiftUI

class AddIncomeViewModel: ObservableObject {
    @Published var income: Income
    @Published var selectedIncome: Income
    var types: Types {
        GlobalData.shared.types
    }
    var templateModels: [TemplateModel]  {
        GlobalData.shared.templateModels.filter { result in
            result.type == "Income"
        }
    }
    @Published var isLoading = false
    
    var labels: [String] {
        types.labelTypes.map { result in
            result.name
        }
    }
    var accounts: [String] {
        types.accountTypes.map { result in
            result.name
        }
    }
    var categories: [String] {
        types.incomeTypes.filter({ category in
            category.isMainCategory
        }).map { result in
            result.name
        }
    }
    var subcategories: [String] {
        guard !selectedCategory.isEmpty else {
            return []
        }
        
        return types.incomeTypes.filter({ category in
            guard let subcategoryOf = category.subcategoryOf else {
                return false
            }
            return subcategoryOf.contains { subcategory in
                subcategory == selectedCategory
            }
        }).map { result in
            result.name
        }
    }
    var isSubCategoryDisabled: Bool {
        subcategories.isEmpty
    }
    
    @Published var valueString = ""
    var value: Double {
        valueString.toDouble() ?? 0
    }
    
    @Published var selectedLabel = "Wil"
    @Published var selectedAccount = ""
    @Published var selectedCategory = ""
    @Published var selectedSubcategory = ""
    @Published var note = ""
    @Published var selectedTemplateIndex = -1
    @Published var date = Date()
    
    var saveTitle: String {
        isUpdate ? "Update" : "Save"
    }
    var isUpdate: Bool = false
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    var isChanged: Bool {
        (
            value != selectedIncome.value ||
            selectedLabel != selectedIncome.label ?? "Wil" ||
            selectedAccount != selectedIncome.account ?? "" ||
            selectedCategory != selectedIncome.category ?? "" ||
            selectedSubcategory != selectedIncome.subcategory ?? "" ||
            !date.isSameDate(with: selectedIncome.date ?? Date()) ||
            note != selectedIncome.note ?? "" ||
            isDoneExport != selectedIncome.isDoneExport
        )
    }
    
    init(income: Income?) {
        if let income = income {
            selectedIncome = income
            self.income = income
            note = income.note ?? ""
            if let value = income.value {
                valueString = value.splitDigit()
            }
            selectedLabel = income.label ?? "Wil"
            selectedAccount = income.account ?? ""
            selectedCategory = income.category ?? ""
            selectedSubcategory = income.subcategory ?? ""
            date = income.date ?? Date()
            isDoneExport = income.isDoneExport
            
            if !income.blockID.isEmpty {
                isUpdate = true
            }
        } else {
            date = Date()
            let defaultIncome = Income(
                blockID: "",
                id: UUID().uuidString,
                yearMonth: "",
                value: 0,
                account: "",
                category: "",
                subcategory: "",
                note: ""
            )
            self.income = defaultIncome
            self.selectedIncome = defaultIncome
            self.income.date = date
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
    
    func save(completion: @escaping (_ isSuccess: Bool, _ income: Income, _ dismissType: DismissType) -> Void) {
        do {
            income.note = note.trimWhitespace()
            income.value = try Validation.numberTextField(valueString)
            income.label = try Validation.picker(selectedLabel, typeError: .noLabel)
            income.account = try Validation.picker(selectedAccount, typeError: .noAccount)
            income.category = try Validation.picker(selectedCategory, typeError: .noCategory)
            income.subcategory = selectedSubcategory.isEmpty ? nil : selectedSubcategory
            income.date = date
            income.isDoneExport = isDoneExport
            
            YearMonthCheck.shared.getYearMonthID(date) { id in
                if let yearMonth = self.income.yearMonth,
                   !yearMonth.isEmpty {
                    self.income.yearMonthID = yearMonth
                } else {
                    self.income.yearMonthID = id
                }
                
                self.isLoading = true
                if self.isUpdate {
                    Networking.shared.updateIncome(self.income) { isSuccess in
                        self.isLoading = false
                        return completion(isSuccess, self.income, .updateSingle)
                    }
                } else {
                    Networking.shared.postIncome(self.income) { isSuccess in
                        self.isLoading = false
                        return completion(isSuccess, self.income, .refreshAll)
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
    
    //MARK: - Template
    @Published var isShowTemplateAddScreen = false
    @Published var templateModel: TemplateModel? = nil
    
    func addTemplate() {
        templateModel = TemplateModel(
            blockID: "",
            name: note,
            account: selectedAccount,
            category: selectedCategory,
            subcategory: selectedSubcategory,
            duration: "Monthly",
            payment: "",
            store: "",
            type: "Income",
            value: value
        )
        
        isShowTemplateAddScreen.toggle()
    }
    
    func applyTemplate(at index: Int) {
        guard index >= 0 else {
            return
        }
        let selectedTemplateModel = templateModels[index]
        
        if let name = selectedTemplateModel.name {
            note = name
        }
        if let selectedLabel = selectedTemplateModel.label {
            self.selectedLabel = selectedLabel
        }
        if let selectedAccount = selectedTemplateModel.account {
            self.selectedAccount = selectedAccount
        }
        if let selectedCategory = selectedTemplateModel.category {
            self.selectedCategory = selectedCategory
        }
        if let selectedSubcategory = selectedTemplateModel.subcategory {
            self.selectedSubcategory = selectedSubcategory
        }
        if let valueString = selectedTemplateModel.value {
            self.valueString = valueString.splitDigit()
        }
    }
    
    //MARK: - CopyExport
    @Published var isDoneExport = false
    
    func shareIncome(completion: (String) -> Void) {
        do {
            let value = try Validation.numberTextField(valueString)
            let valueString = value.splitDigit(with: ",")
            let label = try Validation.picker(selectedLabel, typeError: .noLabel)
            let account = try Validation.picker(selectedAccount, typeError: .noAccount)
            let dateString = date.toString(format: "yyyy.MM.dd")
            
            completion("\(dateString) | \(account) | \(valueString) | \(label)")
        } catch let error {
            if let error = error as? ValidationError {
                if let errorMessage = error.errorMessage {
                    self.errorMessage = errorMessage
                    isShowErrorMessage = true
                }
            }
        }
    }
    
    func copyNote() {
        UIPasteboard.general.string = note.trimWhitespace()
    }
}
