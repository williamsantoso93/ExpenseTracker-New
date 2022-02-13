//
//  AddTemplateViewModel.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

class AddTemplateViewModel: ObservableObject {
    @Published var templateModel: TemplateModel
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
    @Published var selectedCategory = ""
    @Published var selectedPayment = ""
    @Published var selectedDuration = "Monthly"
    @Published var selectedType = "Expense"
    @Published var selectedStore = ""
    var isOtherStore: Bool {
        selectedStore == "Other"
    }
    @Published var otherStore = ""
    
    @Published var saveTitle = "Save"
    var isUpdate: Bool = false
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    var category: [String] {
        [
            "Income",
            "Expense",
        ]
    }
    
    init(templateModel: TemplateModel?) {
        if let templateModel = templateModel {
            self.templateModel = templateModel
            name = templateModel.name ?? ""
            if let value = templateModel.value {
                valueString = value.splitDigit()
            }
            selectedDuration = templateModel.duration ?? ""
            selectedPayment = templateModel.paymentVia ?? ""
            selectedCategory = templateModel.category ?? ""
            checkStore(templateModel.store)
            
            isUpdate = true
            saveTitle = "Update"
        } else {
            self.templateModel = TemplateModel(
                blockID: "",
                name: "",
                account: "",
                category: "",
                subcategory: "",
                duration: "",
                paymentVia: "",
                store: "",
                type: "",
                value: 0
            )
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
        templateModel.paymentVia = selectedPayment
        templateModel.category = selectedCategory
        templateModel.category = selectedType
        templateModel.store = getStore()
        
        templateModel.name = name.isEmpty ? templateModel.store : name
        
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
