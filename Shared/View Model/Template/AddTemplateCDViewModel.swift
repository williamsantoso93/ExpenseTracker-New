//
//  AddTemplateCDViewModel.swift
//  ExpenseTracker
//
//  Created by William Santoso on 09/03/22.
//

import Foundation

class AddTemplateCDViewModel: ObservableObject {
    let coreDataManager = CoreDataManager.shared
    
    @Published var templateModelCD: TemplateModelCD
    @Published var selectedTemplateModelCD: TemplateModelCD
    
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
    
    var typesCategory: [String] {
        [
            "income",
            "expense",
        ]
    }
    
    @Published var valueString = ""
    var value: Double {
        valueString.toDouble() ?? 0
    }
    
    @Published var name = ""
    @Published var selectedLabel = LabelModel(name: "")
    @Published var selectedAccount = Account(name: "")
    @Published var selectedCategory = Category(name: "", type: "")
    @Published var selectedSubcategory = Subcategory(name: "")
    @Published var selectedPayment = Payment(name: "")
    @Published var selectedDuration = Duration(name: "")
    @Published var selectedType = "expense"
    
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
    
    @Published var date = Date()
    
    var saveTitle: String {
        isUpdate ? "Update" : "Save"
    }
    
    var isUpdate: Bool = false
    
    var isChanged: Bool {
        (
            name != selectedTemplateModelCD.name ||
            value != selectedTemplateModelCD.value ||
            selectedLabel.id != selectedTemplateModelCD.label?.id ||
            selectedAccount.id != selectedTemplateModelCD.account?.id ||
            selectedCategory.id != selectedTemplateModelCD.category?.id ||
            selectedSubcategory.id != selectedTemplateModelCD.subcategory?.id ||
            selectedPayment.id != selectedTemplateModelCD.payment?.id ||
            selectedDuration.id != selectedTemplateModelCD.duration?.id ||
            date != selectedTemplateModelCD.date ||
            ((selectedStore.name.lowercased() != "other" && selectedStore.name.lowercased() != selectedTemplateModelCD.store ?? "") ||
             (selectedStore.name.lowercased() == "Other" && otherStore != selectedTemplateModelCD.store ?? "")) ||
            selectedType != selectedTemplateModelCD.type
        )
    }
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    init(templateModelCD: TemplateModelCD?) {
        stores = coreDataManager.getStores()
        if let templateModelCD = templateModelCD {
            self.templateModelCD = templateModelCD
            selectedTemplateModelCD = templateModelCD
            
            valueString = templateModelCD.value.splitDigit()
            if let selectedDuration = templateModelCD.duration {
                self.selectedDuration = selectedDuration
            }
            if let selectedLabel = templateModelCD.label {
                self.selectedLabel = selectedLabel
            }
            if let selectedAccount = templateModelCD.account {
                self.selectedAccount = selectedAccount
            }
            if let selectedCategory = templateModelCD.category {
                self.selectedCategory = selectedCategory
            }
            if let selectedSubcategory = templateModelCD.subcategory {
                self.selectedSubcategory = selectedSubcategory
            }
            if let selectedPayment = templateModelCD.payment {
                self.selectedPayment = selectedPayment
            }
            date = templateModelCD.date
            selectedType = templateModelCD.type
            
            checkStore(templateModelCD.store)
            name = templateModelCD.name ?? ""
            
            isUpdate = true
        } else {
            let defaultTemplateModelCD = TemplateModelCD(type: "expense")
            self.templateModelCD = defaultTemplateModelCD
            selectedTemplateModelCD = defaultTemplateModelCD
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
    
    func save(completion: @escaping (_ isSuccess: Bool) -> Void) {
        templateModelCD.value = value
        templateModelCD.duration = selectedDuration.name.isEmpty ? nil : selectedDuration
        templateModelCD.payment = selectedPayment.name.isEmpty ? nil : selectedPayment
        templateModelCD.label = selectedLabel.name.isEmpty ? nil : selectedLabel
        templateModelCD.account = selectedAccount.name.isEmpty ? nil : selectedAccount
        templateModelCD.category = selectedCategory.name.isEmpty ? nil : selectedCategory
        templateModelCD.subcategory = selectedSubcategory.name.isEmpty ? nil : selectedSubcategory
        templateModelCD.type = selectedType
        templateModelCD.store = getStore()
        
        templateModelCD.name = name.isEmpty ? templateModelCD.store : name.trimWhitespace()
        
        
        if isUpdate {
            coreDataManager.updateTemplateModel(templateModelCD)
        } else {
            coreDataManager.createTemplateModel(templateModelCD)
        }
        completion(true)
    }
    
    func delete(completion: @escaping (Bool) -> Void) {
        coreDataManager.deleteTemplateModel(templateModelCD)
        completion(true)
    }
}
