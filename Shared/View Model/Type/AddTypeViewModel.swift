//
//  AddTypeViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 25/12/21.
//

import Foundation

class AddTypeViewModel: ObservableObject {
    @Published var typeModel: TypeModel
    @Published var isLoading = false
    
    @Published var name = ""
    @Published var selectedCategory = ""
    
    var category: [String] {
        Types.TypeCategory.allCases.map { result in
            result.rawValue.capitalized
        }
    }
    
    @Published var saveTitle = "Save"
    var isUpdate: Bool = false
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    init(typeModel: TypeModel? = nil) {
        if let typeModel = typeModel {
            self.typeModel = typeModel
            
            name = typeModel.name
            selectedCategory = typeModel.category
            
            isUpdate = true
            saveTitle = "Update"
        } else {
            self.typeModel = TypeModel(
                blockID: "",
                name: "",
                category: ""
            )
        }
    }
    
    func save(completion: @escaping (_ isSuccess: Bool) -> Void) {
        do {
            typeModel.category = try Validation.picker(selectedCategory, typeError: .noCategory)
            typeModel.name = try Validation.textField(name)
            
            isLoading = true
            if isUpdate {
                self.isLoading = false
                Networking.shared.updateType(typeModel) { isSuccess in
                    return completion(isSuccess)
                }
            } else {
                self.isLoading = false
                Networking.shared.postType(typeModel) { isSuccess in
                    return completion(isSuccess)
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
}
