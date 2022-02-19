//
//  TypeScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 23/12/21.
//

import SwiftUI

struct TypeScreen: View {
    @ObservedObject var globalData = GlobalData.shared
    
    @StateObject var viewModel = TypeViewModel()
        
    var body: some View {
        Form {
            if !globalData.types.allTypes.isEmpty {
                ForEach(Types.TypeCategory.allCases, id:\.self) { type in
                    let types = viewModel.filterType(type)
                    
                    Section(header: Text(type.rawValue)) {
                        ForEach(types.indices, id:\.self) { index in
                            let type = types[index]
                            
                            Button {
                                viewModel.selectType(type)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text("\(type.isMainCategory ? "main " : "")category : \(type.name)")
                                    Text("subcategoryOf : \(type.subcategoryOf?.joinedWithComma() ?? "-")")
                                    Text("nature : \(type.nature ?? "-")")
                                }
                            }
                        }
                        .onDelete { offsets in
                            viewModel.delete(types, at: offsets)
                        }
                    }
                }
            }
        }
        .loadingWithNoDataButton(globalData.isLoading, isShowNoData: viewModel.isNowShowData, action: {
            viewModel.isShowAddScreen.toggle()
        })
        .searchable(text: $viewModel.searchText)
        .navigationTitle("Types")
        .refreshable {
            globalData.getTypes()
        }
        .toolbar {
            ToolbarItem {
                HStack {
#if os(iOS)
                    EditButton()
#endif
                    
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
                globalData.getTypes()
            }
        }
    }
}

struct TypeScreen_Previews: PreviewProvider {
    static var previews: some View {
        TypeScreen()
    }
}
