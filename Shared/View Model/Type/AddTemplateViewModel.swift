//
//  AddTemplateViewModel.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

class AddTemplateViewModel: ObservableObject {
    @Published var templateExpense: TemplateExpense
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
    
    @Published var saveTitle = "Save"
    var isUpdate: Bool = false
    
    init(templateExpense: TemplateExpense? = nil) {
        if let templateExpense = templateExpense {
            self.templateExpense = templateExpense
            name = templateExpense.name ?? ""
            if let value = templateExpense.value {
                valueString = value.splitDigit()
            }
            selectedDuration = templateExpense.duration ?? ""
            selectedPayment = templateExpense.paymentVia ?? ""
            selectedType = templateExpense.type ?? ""
            
            isUpdate = true
            saveTitle = "Update"
        } else {
            self.templateExpense = TemplateExpense(
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
        templateExpense.name = name
        templateExpense.value = value
        templateExpense.duration = selectedDuration
        templateExpense.paymentVia = selectedPayment
        templateExpense.type = selectedType
        
        isLoading = true
        if isUpdate {
            Networking.shared.updateTemplateExpense(templateExpense) { isSuccess in
                self.isLoading = false
                return completion(isSuccess)
            }
        } else {
            Networking.shared.postTemplateExpense(templateExpense) { isSuccess in
                self.isLoading = false
                return completion(isSuccess)
            }
        }
    }
}
