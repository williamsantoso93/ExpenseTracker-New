//
//  TypeScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 23/12/21.
//

import SwiftUI

struct TypeScreen: View {
    @ObservedObject var globalData = GlobalData.shared
    @State private var isShowAddScreen = false
    @State private var selectedType: TypeModel?
    
    @StateObject var viewModel = TypeViewModel()
        
    var body: some View {
        Form {
            if !globalData.types.allTypes.isEmpty {
                ForEach(Types.TypeCategory.allCases, id:\.self) { type in
                    let types = viewModel.filterType(type)
                    
                    Section(header: Text(type.rawValue)) {
                        ForEach(types.indices, id:\.self) {index in
                            let type = types[index]
                            
                            Button {
                                selectedType = type
                                isShowAddScreen.toggle()
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(type.name)
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
                        isShowAddScreen.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isShowAddScreen) {
            selectedType = nil
        } content: {
            AddTypeScreen(typeModel: selectedType) {
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
