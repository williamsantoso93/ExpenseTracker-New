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
    
    @Published var valueString = ""
    var value: Int {
        valueString.toInt()
    }
    @Published var name = ""
    @Published var selectedType = ""
    @Published var selectedPayment = ""
    @Published var selectedDuration = ""
    @Published var selectedCategory = ""
    
    @Published var saveTitle = "Save"
    var isUpdate: Bool = false
    
    var category: [String] {
        [
            "Income",
            "Expense",
        ]
    }
    
    init(templateModel: TemplateModel? = nil) {
        if let templateModel = templateModel {
            self.templateModel = templateModel
            name = templateModel.name ?? ""
            if let value = templateModel.value {
                valueString = value.splitDigit()
            }
            selectedDuration = templateModel.duration ?? ""
            selectedPayment = templateModel.paymentVia ?? ""
            selectedType = templateModel.type ?? ""
            
            isUpdate = true
            saveTitle = "Update"
        } else {
            self.templateModel = TemplateModel(
                blockID: "",
                name: "",
                duration: "",
                paymentVia: "",
                type: "",
                value: 0
            )
        }
    }
    
    @Published var isLoading = false
    
    func save(completion: @escaping (_ isSuccess: Bool) -> Void) {
        templateModel.name = name
        templateModel.value = value
        templateModel.duration = selectedDuration
        templateModel.paymentVia = selectedPayment
        templateModel.type = selectedType
        templateModel.category = selectedCategory
        
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
