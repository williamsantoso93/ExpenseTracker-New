//
//  AddTypeViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 25/12/21.
//

import Foundation

class AddTypeViewModel: ObservableObject {
    @Published var typeModel: TypeModel
    
    @Published var name = ""
    @Published var selectedCategory = ""
    
    var category: [String] {
        Types.TypeCategory.allCases.map { result in
            result.rawValue.capitalized
        }
    }
    
    @Published var saveTitle = "Save"
    var isUpdate: Bool = false
    
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
        typeModel.name = name
        typeModel.category = selectedCategory
        
        if isUpdate {
            Networking.shared.updateType(typeModel) { isSuccess in
                return completion(isSuccess)
            }
        } else {
            Networking.shared.postType(typeModel) { isSuccess in
                return completion(isSuccess)
            }
        }
    }
}
