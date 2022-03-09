//
//  AddIncomeCDViewModel.swift
//  ExpenseTracker
//
//  Created by William Santoso on 09/03/22.
//

import Foundation

class AddIncomeCDViewModel: ObservableObject {
    let coreDataManager = CoreDataManager.shared
    
    @Published var incomeCD: IncomeCD
    @Published var selectedIncomeCD: IncomeCD
    
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
    
    @Published var valueString = ""
    var value: Double {
        valueString.toDouble() ?? 0
    }
    
    @Published var selectedLabel = LabelModel(name: "")
    @Published var selectedAccount = Account(name: "")
    @Published var selectedCategory = Category(name: "", type: "")
    @Published var selectedSubcategory = Subcategory(name: "")
    
    @Published var selectedTemplateIndex = -1
    @Published var note = ""
    @Published var date = Date()
    
    var saveTitle: String {
        isUpdate ? "Update" : "Save"
    }
    
    var isUpdate: Bool = false
    
    var isChanged: Bool {
        (
            value != selectedIncomeCD.value ||
            selectedLabel.id != selectedIncomeCD.label?.id ||
            selectedAccount.id != selectedIncomeCD.account?.id ||
            selectedCategory.id != selectedIncomeCD.category?.id ||
            selectedSubcategory.id != selectedIncomeCD.subcategory?.id ||
            date != selectedIncomeCD.date ||
            note != selectedIncomeCD.note
        )
    }
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    init(incomeCD: IncomeCD?) {
        if let incomeCD = incomeCD {
            self.incomeCD = incomeCD
            selectedIncomeCD = incomeCD
            
            valueString = incomeCD.value.splitDigit()
            if let selectedLabel = incomeCD.label {
                self.selectedLabel = selectedLabel
            }
            if let selectedAccount = incomeCD.account {
                self.selectedAccount = selectedAccount
            }
            if let selectedCategory = incomeCD.category {
                self.selectedCategory = selectedCategory
            }
            if let selectedSubcategory = incomeCD.subcategory {
                self.selectedSubcategory = selectedSubcategory
            }
            date = incomeCD.date
            
            note = incomeCD.note ?? ""
            isUpdate = true
        } else {
            let defaultIncomeCD = IncomeCD()
            self.incomeCD = defaultIncomeCD
            selectedIncomeCD = defaultIncomeCD
        }
        
        getData()
    }
    
    func getData() {
        labels = coreDataManager.getLabels()
        accounts = coreDataManager.getAccounts()
        categories = coreDataManager.getCategories()
        allSubcategories = coreDataManager.getSubcategories()
        
        templateModelCDs = coreDataManager.getTemplateModels().filter{ result in
            result.type.lowercased() == "expense"
        }
    }
    
    func save(completion: @escaping (Bool) -> Void) {
        do {
            incomeCD.value = try Validation.numberTextField(valueString)
            incomeCD.label = try Validation.picker(inputName: selectedLabel.name, input: selectedLabel, typeError: .noLabel) as? LabelModel
            incomeCD.account = try Validation.picker(inputName: selectedAccount.name, input: selectedAccount, typeError: .noAccount) as? Account
            incomeCD.category = try Validation.picker(inputName: selectedCategory.name, input: selectedCategory, typeError: .noCategory) as? Category
            incomeCD.subcategory = try Validation.picker(inputName: selectedSubcategory.name, input: selectedSubcategory, typeError: .noSubcategory) as? Subcategory
            incomeCD.note = note.trimWhitespace()
            incomeCD.date = date
            
            if isUpdate {
                coreDataManager.updateIncome(incomeCD)
            } else {
                coreDataManager.createIncome(incomeCD)
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
        coreDataManager.deleteIncome(incomeCD)
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
        if selectedTemplateModel.value != 0 {
            self.valueString = selectedTemplateModel.value.splitDigit()
        }
        if let name = selectedTemplateModel.name {
            note = name
        }
    }
}
