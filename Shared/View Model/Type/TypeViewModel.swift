//
//  TypeViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation
import Combine

class TypeViewModel: ObservableObject {
    @Published var globalData = GlobalData.shared
    @Published var isLoading = false
    var isNowShowData: Bool {
        globalData.types.allTypes.isEmpty
    }
    var cancelables = Set<AnyCancellable>()
    
    @Published var searchText = ""
    func filterType(_ category: Types.TypeCategory) -> [TypeModel] {
        let types = globalData.types.allTypes.filter { type in
            type.type == category.rawValue.capitalized
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
            let id = typeModels[index].blockID
            
            print(index)
            print(typeModels[index])
            if let allTypeIndex = getAllTypesIndex(from: id) {
                isLoading = true
                
                do {
                    try Networking.shared.delete(id: id)
                        .sink { _ in
                            self.isLoading = false
                        } receiveValue: { isSuccess in
                            if isSuccess {
                                self.globalData.types.allTypes.remove(at: allTypeIndex)
                            }
                        }
                        .store(in: &self.cancelables)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getAllTypesIndex(from id: String) -> Int? {
        globalData.types.allTypes.firstIndex { result in
            result.blockID == id
        }
    }
    
    @Published var isShowAddScreen = false
    var selectedType: TypeModel? = nil
    
    func selectType(_ type: TypeModel? = nil) {
        selectedType = type
        isShowAddScreen = true
    }
}
