//
//  TypeViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

class TypeViewModel: ObservableObject {
    @Published var globalData = GlobalData.shared
    @Published var isLoading = false
    var isNowShowData: Bool {
        globalData.types.allTypes.isEmpty
    }
    
    @Published var searchText = ""
    func filterType(_ category: TypeCategory) -> [TypeModel] {
        let types = globalData.types.allTypes.filter { type in
            type.category == category.rawValue.capitalized
        }
        guard !searchText.isEmpty else {
            return types
        }
        
        return types.filter { result in
            result.keywords?.lowercased().contains(searchText.lowercased()) ?? false
        }
    }
    
    func delete(_ typeModels: [TypeModel], at offsets: IndexSet) {
        offsets.forEach { index in
            guard let id = typeModels[index].notionID else { return }
            
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
            result.notionID == id
        }
    }
    
    @Published var isShowAddScreen = false
    var selectedType: TypeModel? = nil
    
    func selectType(_ type: TypeModel? = nil) {
        selectedType = type
        isShowAddScreen = true
    }
}
