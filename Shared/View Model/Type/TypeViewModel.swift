//
//  TypeViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

class TypeViewModel: ObservableObject {
    @Published var globalData = GlobalData.shared
    func filterType(_ category: Types.TypeCategory) -> [TypeModel] {
        globalData.types.allTypes.filter { type in
            type.category == category.rawValue.capitalized
        }
    }
    
    func delete(_ typeModels: [TypeModel], at offsets: IndexSet) {
        offsets.forEach { index in
            let id = typeModels[index].blockID
            
            print(index)
            print(typeModels[index])
            if let allTypeIndex = getAllTypesIndex(from: id) {
                Networking.shared.delete(id: id) { isSuccess in
                    if isSuccess {
                        self.globalData.types.allTypes.remove(at: allTypeIndex)
                    }
                }
            }
        }
    }
    
    func getAllTypesIndex(from id: String) -> Int? {
        globalData.types.allTypes.firstIndex { result in
            result.blockID == id
        }
    }
}
