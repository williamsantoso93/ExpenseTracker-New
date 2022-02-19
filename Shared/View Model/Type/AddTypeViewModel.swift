//
//  AddTypeViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 25/12/21.
//

import Foundation

class AddTypeViewModel: ObservableObject {
    @Published var types = GlobalData.shared.types
    
    @Published var typeModel: TypeModel
    @Published var isLoading = false
    
    @Published var name = ""
    @Published var selectedType = "Expense"
    @Published var selectedSubcategoryOf: [String] = []
    @Published var selectedNature = "Must"
    
    let natures = [
        "Must",
        "Need",
        "Want"
    ]
    
    var typesCategory: [String] {
        Types.TypeCategory.allCases.map { result in
            result.rawValue.capitalized
        }
    }
    
    var subcategoriesOf: [String] {
        types.allTypes.filter({ category in
            category.type == selectedType && category.isMainCategory
        }).map { result in
            result.name
        }
    }
    var isSubCategoryDisabled: Bool {
        subcategoriesOf.isEmpty
    }
    
    @Published var saveTitle = "Save"
    var isUpdate: Bool = false
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    init(typeModel: TypeModel?) {
        if let typeModel = typeModel {
            self.typeModel = typeModel
            
            name = typeModel.name
            selectedType = typeModel.type
            selectedSubcategoryOf = typeModel.subcategoryOf ?? []
            selectedNature = typeModel.nature ?? "Must"
            
            isUpdate = true
            saveTitle = "Update"
        } else {
            self.typeModel = TypeModel(
                blockID: "",
                name: "",
                type: "",
                subcategoryOf: [],
                nature: ""
            )
        }
    }
    
    func delete(completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard !typeModel.blockID.isEmpty else { return }
        
        isLoading = true
        Networking.shared.delete(id: typeModel.blockID) { isSuccess in
            self.isLoading = false
            return completion(isSuccess)
        }
    }
    
    func save(completion: @escaping (_ isSuccess: Bool) -> Void) {
        do {
            typeModel.type = try Validation.picker(selectedType, typeError: .noType)
            typeModel.name = try Validation.textField(name)
            typeModel.subcategoryOf = selectedSubcategoryOf.isEmpty ? nil : selectedSubcategoryOf
            typeModel.nature = selectedNature
            
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
