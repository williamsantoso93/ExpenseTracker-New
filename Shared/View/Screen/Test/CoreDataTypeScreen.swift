//
//  CoreDataTypeScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 10/01/22.
//

import SwiftUI

class CoreDataTypeViewModel: ObservableObject {
    @Published var globalData = GlobalData.shared
    @Published var isShowAddScreen = false
    var selectedType: TypeModel? = nil
    
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
            let type = typeModels[index]
            do {
                try CoreDataManager.shared.deleteType(type)
                
                if let allTypeIndex = getAllTypesIndex(from: type.id) {
                    self.globalData.types.allTypes.remove(at: allTypeIndex)
                    globalData.getTypesCoreData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getAllTypesIndex(from id: String) -> Int? {
        globalData.types.allTypes.firstIndex { result in
            result.id == id
        }
    }
    
    func selectType(_ type: TypeModel? = nil) {
        selectedType = type
        isShowAddScreen = true
    }
}

struct CoreDataTypeScreen: View {
    @ObservedObject var globalData = GlobalData.shared
    @StateObject var viewModel = CoreDataTypeViewModel()
    
    var body: some View {
        Form {
            if !globalData.types.allTypes.isEmpty {
                ForEach(TypeCategory.allCases, id:\.self) { type in
                    let types = viewModel.filterType(type)
                    
                    Section(header: Text(type.rawValue)) {
                        ForEach(types.indices, id:\.self) { index in
                            let type = types[index]
                            
                            Button {
                                viewModel.selectType(type)
                            } label: {
                                TypeCellView(type: type)
                            }
                        }
                        .onDelete { offsets in
                            viewModel.delete(types, at: offsets)
                        }
                    }
                }
            }
        }
        .onAppear(perform: globalData.getTypesCoreData)
        .refreshable {
            globalData.getTypesCoreData()
        }
        .navigationTitle("Type - CoreData")
        .toolbar {
            ToolbarItem {
                HStack {
                    EditButton()
                    
                    Button {
                        viewModel.selectType()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowAddScreen) {
            viewModel.selectedType = nil
        } content: {
            AddTypeScreen(typeModel: viewModel.selectedType) {
                globalData.getTypesCoreData()
                viewModel.isShowAddScreen.toggle()
            }
        }
    }
}

struct CoreDataTypeScreen_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            CoreDataTypeScreen()
        }
    }
}
