//
//  AddExpenseCDViewModel.swift
//  ExpenseTracker
//
//  Created by William Santoso on 09/03/22.
//

import Foundation

class AddExpenseCDViewModel: AddViewModel {
    let coreDataManager = CoreDataManager.shared
    
    @Published var expenseCD: ExpenseCD
    @Published var selectedExpenseCD: ExpenseCD
    
    @Published var templateModelCDs: [TemplateModelCD] = []
    @Published var labels: [LabelModel] = []
    @Published var accounts: [Account] = []
    @Published var categories: [Category] = []
    @Published var allSubcategories: [Subcategory] = []
    var subcategories: [Subcategory] {
        allSubcategories.filter({ item in
            item.mainCategory?.id == selectedCategory.id
        })
    }
    var isSubCategoryDisabled: Bool {
        subcategories.isEmpty
    }
    @Published var payments: [Payment] = []
    @Published var durations: [Duration] = []
    @Published var stores: [Store] = []
    
    @Published var valueString = ""
    var value: Double {
        valueString.toDouble() ?? 0
    }
    
    @Published var selectedLabel = LabelModel(name: "")
    @Published var selectedAccount = Account(name: "")
    @Published var selectedCategory = Category(name: "", type: "")
    @Published var selectedSubcategory = Subcategory(name: "")
    @Published var selectedPayment = Payment(name: "")
    @Published var selectedDuration = Duration(name: "")
    
    @Published var selectedStore = Store(isHaveMultipleStore: false, name: "")
    var isHaveMultipleStore: Bool {
        guard !stores.isEmpty else { return false }
        
        let store = stores.first { store in
            store.name.lowercased() == selectedStore.name.lowercased()
        }
        
        return store?.isHaveMultipleStore ?? false
    }
    var isOtherStore: Bool {
        selectedStore.name.lowercased() == "other" || isHaveMultipleStore
    }
    @Published var otherStore = ""
    
    @Published var selectedTemplateIndex = -1
    @Published var note = ""
    @Published var date = Date()
    
    var saveTitle: String {
        isUpdate ? "Update" : "Save"
    }
    
    var isUpdate: Bool = false
    
    var isChanged: Bool {
        value != selectedExpenseCD.value ||
        selectedLabel.id != selectedExpenseCD.label?.id ||
        selectedAccount.id != selectedExpenseCD.account?.id ||
        selectedCategory.id != selectedExpenseCD.category?.id ||
        selectedSubcategory.id != selectedExpenseCD.subcategory?.id ||
        selectedPayment.id != selectedExpenseCD.payment?.id ||
        selectedDuration.id != selectedExpenseCD.duration?.id ||
        date != selectedExpenseCD.date ||
        ((selectedStore.name.lowercased() != "other" && selectedStore.name.lowercased() != selectedExpenseCD.store ?? "") ||
         (selectedStore.name.lowercased() == "Other" && otherStore != selectedExpenseCD.store ?? "")) ||
        note != selectedExpenseCD.note
    }
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    init(expenseCD: ExpenseCD?) {
//        labels = coreDataManager.getLabels()
        accounts = coreDataManager.getAccounts()
//        categories = coreDataManager.getCategories()
//        payments = coreDataManager.getPayments()
//        durations = coreDataManager.getDurations()
        stores = coreDataManager.getStores()
//
//        templateModelCDs = coreDataManager.getTemplateModels().filter{ result in
//            result.type.lowercased() == "expense"
//        }
        if let expenseCD = expenseCD {
            self.expenseCD = expenseCD
            selectedExpenseCD = expenseCD
            
            valueString = expenseCD.value.splitDigit()
            if let selectedDuration = expenseCD.duration {
                self.selectedDuration = selectedDuration
            }
            if let selectedLabel = expenseCD.label {
                self.selectedLabel = selectedLabel
            }
            if let selectedAccount = expenseCD.account {
                self.selectedAccount = selectedAccount
            }
            if let selectedCategory = expenseCD.category {
                self.selectedCategory = selectedCategory
            }
            if let selectedSubcategory = expenseCD.subcategory {
                self.selectedSubcategory = selectedSubcategory
            }
            if let selectedPayment = expenseCD.payment {
                self.selectedPayment = selectedPayment
            }
            date = expenseCD.date
            
            checkStore(expenseCD.store)
            note = expenseCD.note ?? ""
            
            isUpdate = true
        } else {
            let defaultExpenseCD = ExpenseCD()
            self.expenseCD = defaultExpenseCD
            selectedExpenseCD = defaultExpenseCD
            if let otherStore = getOtherStore() {
                selectedStore = otherStore
            }
        }
        getData()
    }
    
    func getData() {
        labels = coreDataManager.getLabels()
        accounts = coreDataManager.getAccounts()
        categories = coreDataManager.getCategories()
        allSubcategories = coreDataManager.getSubcategories()
        payments = coreDataManager.getPayments()
        durations = coreDataManager.getDurations()
        stores = coreDataManager.getStores()
        
        templateModelCDs = coreDataManager.getTemplateModels().filter{ result in
            result.type.lowercased() == "expense"
        }
    }
    
    func checkStore(_ store: String?) {
        let selectedStoreString = store ?? "other"
        if selectedStoreString.lowercased() == "other" {
            if let otherStore = getOtherStore() {
                self.otherStore = selectedStoreString
                selectedStore = otherStore
            }
        } else {
            if let selectedStore = getStore(from: selectedStoreString) {
                self.selectedStore = selectedStore
            }
        }
    }
    
    func getStore(from storeName: String) -> Store? {
        stores.first { store in
            store.name.lowercased() == storeName.lowercased()
        }
    }
    
    func getOtherStore() -> Store? {
        getStore(from: "other")
    }
    
    func getStore() -> String {
        if isOtherStore {
            return otherStore
        } else {
            return selectedStore.name
        }
    }
    
    func save(completion: @escaping (Bool) -> Void) {
        do {
            expenseCD.value = try Validation.numberTextField(valueString)
            expenseCD.label = try Validation.picker(inputName: selectedLabel.name, input: selectedLabel, typeError: .noLabel) as? LabelModel
            expenseCD.account = try Validation.picker(inputName: selectedAccount.name, input: selectedAccount, typeError: .noAccount) as? Account
            expenseCD.category = try Validation.picker(inputName: selectedCategory.name, input: selectedCategory, typeError: .noCategory) as? Category
            expenseCD.subcategory = try Validation.picker(inputName: selectedSubcategory.name, input: selectedSubcategory, typeError: .noSubcategory) as? Subcategory
            expenseCD.payment = try Validation.picker(inputName: selectedPayment.name, input: selectedPayment, typeError: .noPayment) as? Payment
            expenseCD.duration = try Validation.picker(inputName: selectedDuration.name, input: selectedDuration, typeError: .noDuration) as? Duration
            if isHaveMultipleStore {
                if !otherStore.isEmpty {
                    expenseCD.store = "\(selectedStore.name) | \(otherStore)"
                } else {
                    expenseCD.store = selectedStore.name
                }
            } else {
                expenseCD.store = getStore().trimWhitespace()
            }
            expenseCD.note = note.trimWhitespace()
            expenseCD.date = date
            
            if isUpdate {
                coreDataManager.updateExpense(expenseCD)
            } else {
                coreDataManager.createExpense(expenseCD)
            }
            completion(true)
        } catch let error {
            if let error = error as? ValidationError {
                if let errorMessage = error.errorMessage {
                    self.errorMessage = errorMessage
                    isShowErrorMessage = true
                }
            }
        }
    }
    
    func delete(completion: @escaping (Bool) -> Void) {
        coreDataManager.deleteExpense(expenseCD)
        completion(true)
    }
    
    //MARK: - Template
    @Published var isShowTemplateAddScreen = false
    @Published var templateModelCD: TemplateModelCD? = nil
    
    func applyTemplate(at index: Int) {
        guard index >= 0 else {
            return
        }
        let selectedTemplateModel = templateModelCDs[index]
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
        if selectedTemplateModel.value != 0 {
            self.valueString = selectedTemplateModel.value.splitDigit()
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
    
    func saveInstallment(completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard installmentMonth > 0 else { return }
        var count = 0
        var expenseCD = self.expenseCD
        expenseCD.duration = durations.first(where: { duration in
            duration.name.lowercased() == "Monthly".lowercased()
        })
        let strValue = String(format: "%.2f", perMonthExpenseWithInterest)
        expenseCD.value = Double(strValue) ?? 0
        
        for installment in 1 ... installmentMonth {
            if installment > 1 {
                if let date = expenseCD.date.addMonth(by: 1) {
                    expenseCD.date = date
                }
            }
            expenseCD.note = note + " | Installment \(installment) to \(installmentMonth)"
            
            coreDataManager.createExpense(expenseCD)
            count += 1
            if count >= self.installmentMonth {
                //                self.isLoading = false
                return completion(true)
            }
        }
    }
}
