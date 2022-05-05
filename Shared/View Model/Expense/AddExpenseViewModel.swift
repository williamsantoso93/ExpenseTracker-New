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
    @Published var selectedExpense: Expense
    var types: Types {
        GlobalData.shared.types
    }
    var templateModels: [TemplateModel]  {
        GlobalData.shared.templateModels.filter { result in
            result.type == "Expense"
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
        types.expenseTypes.filter({ category in
            category.isMainCategory
        }).map { result in
            result.name
        }
    }
    var subcategories: [String] {
        guard !selectedCategory.isEmpty else {
            return []
        }
        
        return types.expenseTypes.filter({ category in
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
    
    @Published var selectedLabel = "Wil"
    @Published var selectedAccount = "" {
        didSet {
            if selectedAccount.contains("CC") {
                selectedPayment = "Credit Card"
            } else if selectedAccount.contains("Cash") {
                selectedPayment = "Cash"
            } else {
                selectedPayment = "Transfer"
            }
        }
    }
    @Published var selectedCategory = ""
    @Published var selectedSubcategory = ""
    @Published var selectedPayment = ""
    @Published var selectedDuration = ""
    
    @Published var selectedStore = "Other"
    var isEcommerceStore: Bool {
        if let subcategory = getStoreSubcategory(from: selectedStore) {
            if subcategory.contains("Store") {
                return true
            }
        }
        
        return false
    }
    var isOtherStore: Bool {
        selectedStore == "Other" || isEcommerceStore
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
    
    var isChanged: Bool {
        (
            value != selectedExpense.value ?? 0 ||
            selectedLabel != selectedExpense.label ?? "Wil" ||
            selectedAccount != selectedExpense.account ?? "" ||
            selectedCategory != selectedExpense.category ?? "" ||
            selectedSubcategory != selectedExpense.subcategory ?? "" ||
            selectedPayment != selectedExpense.payment ||
            selectedDuration != selectedExpense.duration ||
            !date.isSameDate(with: selectedExpense.date ?? Date()) ||
            ((selectedStore != "Other" && selectedStore != selectedExpense.store ?? "") ||
             (selectedStore == "Other" && otherStore != selectedExpense.store ?? "")) ||
            note != selectedExpense.note ?? "" ||
            isDoneExport != selectedExpense.isDoneExport
        )
    }
    
    init(expense: Expense?) {
        if let expense = expense {
            selectedExpense = expense
            self.expense = expense
            if let value = expense.value {
                valueString = value.splitDigit()
            }
            selectedDuration = expense.duration ?? ""
            selectedPayment = expense.payment ?? ""
            selectedLabel = expense.label ?? "Wil"
            selectedAccount = expense.account ?? ""
            selectedCategory = expense.category ?? ""
            selectedSubcategory = expense.subcategory ?? ""
            date = expense.date ?? Date()
            
            checkStore(expense.store)
            note = expense.note ?? ""
            isDoneExport = expense.isDoneExport
            
            if !expense.blockID.isEmpty {
                isUpdate = true
            }
        } else {
            date = Date()
            let defaultExpense = Expense(
                blockID: "",
                id: UUID().uuidString,
                yearMonth: "",
                note: "",
                value: 0,
                account: "",
                category: "",
                subcategory: "",
                duration: "Once",
                payment: "",
                store: ""
            )
            self.expense = defaultExpense
            self.selectedExpense = defaultExpense
            selectedDuration = "Once"
            self.expense.date = date
        }
    }
    
    let noteSeparator = " | "
    
    func getStoreSubcategory(from category: String) -> [String]? {
        if let selectedStore = types.storeTypes.filter({ store in
            store.name == category
        }).first {
            return selectedStore.subcategoryOf
        }
        
        return nil
    }
    
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
    
    func save(completion: @escaping (_ isSuccess: Bool, _ expense: Expense, _ dismissType: DismissType) -> Void) {
        do {
            expense.value = try Validation.numberTextField(valueString)
            expense.label = try Validation.picker(selectedLabel, typeError: .noLabel)
            expense.account = try Validation.picker(selectedAccount, typeError: .noAccount)
            expense.category = try Validation.picker(selectedCategory, typeError: .noCategory)
            expense.subcategory = selectedSubcategory.isEmpty ? nil : selectedSubcategory
            expense.payment = try Validation.picker(selectedPayment, typeError: .noPayment)
            expense.duration = try Validation.picker(selectedDuration, typeError: .noDuration)
            if isEcommerceStore {
                if !otherStore.isEmpty {
                    expense.store = "\(selectedStore) | \(otherStore)"
                } else {
                    expense.store = selectedStore
                }
            } else {
                expense.store = getStore().trimWhitespace()
            }
            let note = note.trimWhitespace()
            expense.note = isInstallment ? try Validation.textField(note, typeError: .noNote) : note
            expense.date = date
            expense.isDoneExport = isDoneExport
            
            YearMonthCheck.shared.getYearMonthID(date) { id in
                self.expense.yearMonthID = id
                
                self.isLoading = true
                if self.isUpdate {
                    Networking.shared.updateExpense(self.expense) { isSuccess in
                        self.isLoading = false
                        return completion(isSuccess, self.expense, .updateSingle)
                    }
                } else {
                    if self.isInstallment && (self.installmentMonth > 0) {
                        self.saveInstallment { isSuccess in
                            self.isLoading = false
                            return completion(isSuccess, self.expense, .refreshAll)
                        }
                    } else {
                        Networking.shared.postExpense(self.expense) { isSuccess in
                            self.isLoading = false
                            return completion(isSuccess, self.expense, .refreshAll)
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
            duration: selectedDuration,
            payment: selectedPayment,
            store: getStore(),
            type: "Expense",
            value: value
        )
        
        isShowTemplateAddScreen.toggle()
    }
    
    func applyTemplate(at index: Int) {
        guard index >= 0 else {
            return
        }
        let selectedTemplateModel = templateModels[index]
        if let selectedDuration = selectedTemplateModel.duration {
            self.selectedDuration = selectedDuration
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
        if let selectedPayment = selectedTemplateModel.payment {
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
        isDoneExport = selectedTemplateModel.isDoneExport
    }
    
    //MARK: - CopyExport
    @Published var isDoneExport = false
        
    func shareExpense(completion: (String) -> Void) {
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
        do {
            var note = note
            var store = ""
            let payment = " paid via " + (try Validation.picker(selectedPayment, typeError: .noPayment))
            if isEcommerceStore {
                if !otherStore.isEmpty {
                    store = "\(selectedStore) | \(otherStore)"
                } else {
                    store = selectedStore
                }
            } else {
                store = getStore().trimWhitespace()
            }
            
            
            if store.isEmpty {
                note = note + payment
            } else {
                note = note + " at " + store + payment
            }
            
            UIPasteboard.general.string = note.trimWhitespace()
        } catch let error {
            if let error = error as? ValidationError {
                if let errorMessage = error.errorMessage {
                    self.errorMessage = errorMessage
                    isShowErrorMessage = true
                }
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
    
    var installmentDates: String? {
        guard installmentMonth > 0 else { return nil }
        var selectedDate: Date? = date
        
        var temp: [String] = []
        
        for installment in 1 ... installmentMonth {
            if installment > 1 {
                selectedDate = selectedDate?.addMonth(by: 1)
            }
            if let dateString = selectedDate?.toString(format: "yyyy/MM/dd") {
                temp.append("\(installment) : \(dateString)")
            }
        }
        
        if !temp.isEmpty {
            return temp.joined(separator: "\n")
        }
        
        return nil
    }
    
    var instalmentNote: String {
        isInstallment ? note + " | Installment " : ""
    }
    
    func saveInstallment(completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard installmentMonth > 0 else { return }
        var count = 0
        var expense = self.expense
        expense.duration = "Monthly"
        let strValue = String(format: "%.2f", perMonthExpenseWithInterest)
        expense.value = Double(strValue) ?? 0
        
        for installment in 1 ... installmentMonth {
            if installment > 1 {
                expense.date = expense.date?.addMonth(by: 1)
            }
            expense.note = instalmentNote + "\(installment) to \(installmentMonth)"
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
