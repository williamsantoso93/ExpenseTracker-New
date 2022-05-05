//
//  AddTemplateViewModel.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

class AddTemplateViewModel: ObservableObject {
    @Published var templateModel: TemplateModel
    @Published var selectedTemplateModel: TemplateModel
    var types: Types {
        GlobalData.shared.types
    }
    
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
    var selectedCategories: [TypeModel] {
        if selectedType == "Expense" {
            return types.expenseTypes
        } else {
            return types.incomeTypes
        }
    }
    var categories: [String] {
        selectedCategories.filter({ category in
            category.isMainCategory
        }).map { result in
            result.name
        }
    }
    var subcategories: [String] {
        guard !selectedCategory.isEmpty else {
            return []
        }
        
        return selectedCategories.filter({ category in
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
    @Published var name = ""
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
    @Published var selectedDuration = "Monthly"
    @Published var selectedType = "Expense"
    @Published var selectedStore = ""
    var isOtherStore: Bool {
        selectedStore == "Other"
    }
    @Published var otherStore = ""
    
    var saveTitle: String {
        isUpdate ? "Update" : "Save"
    }
    var isUpdate: Bool = false
    @Published var isDoneExport = false
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    var typesCategory: [String] {
        [
            "Income",
            "Expense",
        ]
    }
    
    var isChanged: Bool {
        (
            name != selectedTemplateModel.name ||
            value != selectedTemplateModel.value ?? 0 ||
            selectedLabel != selectedTemplateModel.label ||
            selectedAccount != selectedTemplateModel.account ||
            selectedCategory != selectedTemplateModel.category ||
            selectedSubcategory != selectedTemplateModel.subcategory ||
            selectedPayment != selectedTemplateModel.payment ||
            selectedDuration != selectedTemplateModel.duration ||
            ((selectedStore != "Other" && selectedStore != selectedTemplateModel.store ?? "") ||
             (selectedStore == "Other" && otherStore != selectedTemplateModel.store ?? "")) ||
            selectedType != selectedTemplateModel.type ||
            isDoneExport != selectedTemplateModel.isDoneExport
        )
    }
    
    init(templateModel: TemplateModel?) {
        if let templateModel = templateModel {
            selectedTemplateModel = templateModel
            self.templateModel = templateModel
            name = templateModel.name ?? ""
            if let value = templateModel.value {
                valueString = value.splitDigit()
            }
            selectedDuration = templateModel.duration ?? ""
            selectedPayment = templateModel.payment ?? ""
            selectedLabel = templateModel.label ?? ""
            selectedAccount = templateModel.account ?? ""
            selectedCategory = templateModel.category ?? ""
            selectedSubcategory = templateModel.subcategory ?? ""
            selectedType = templateModel.type ?? ""
            checkStore(templateModel.store)
            isDoneExport = templateModel.isDoneExport
            
            if !templateModel.blockID.isEmpty {
                isUpdate = true
            }
        } else {
            let defaultTemplateModel = TemplateModel(
                blockID: "",
                name: "",
                account: "Wil",
                category: "",
                subcategory: "",
                duration: "Monthly",
                payment: "",
                store: "",
                type: "Expense",
                value: 0
            )
            self.templateModel = defaultTemplateModel
            self.selectedTemplateModel = defaultTemplateModel
        }
    }
    
    func checkStore(_ store: String?) {
        selectedStore = store ?? ""
        if let store = store {
            if !storeType.contains(store) && !store.isEmpty {
                otherStore = store
                selectedStore = "Other"
            }
        }
    }
    
    @Published var isLoading = false
    
    func delete(completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard !templateModel.blockID.isEmpty else { return }
        
        isLoading = true
        Networking.shared.delete(id: templateModel.blockID) { isSuccess in
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
    
    func save(completion: @escaping (_ isSuccess: Bool) -> Void) {
        templateModel.value = value
        templateModel.duration = selectedDuration
        templateModel.payment = selectedPayment
        templateModel.label = selectedLabel
        templateModel.account = selectedAccount
        templateModel.category = selectedCategory
        templateModel.subcategory = selectedSubcategory.isEmpty ? nil : selectedSubcategory
        templateModel.type = selectedType
        templateModel.store = getStore()
        templateModel.isDoneExport = isDoneExport
        
        templateModel.name = name.isEmpty ? templateModel.store : name.trimWhitespace()
        
        isLoading = true
        if isUpdate {
            Networking.shared.updateTemplateModel(templateModel) { isSuccess in
                self.isLoading = false
                return completion(isSuccess)
            }
        } else {
            Networking.shared.postTemplateModel(templateModel) { isSuccess in
                self.isLoading = false
                return completion(isSuccess)
            }
        }
    }
}
