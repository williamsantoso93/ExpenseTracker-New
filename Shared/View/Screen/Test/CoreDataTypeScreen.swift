//
//  CoreDataTypeScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 10/01/22.
//

import SwiftUI

struct CoreDataTypeScreen: View {
    @State private var isShowAddScreen = false
    @State private var types: [TypeModel] = []
    
    var body: some View {
        Form {
            ForEach(types.indices, id:\.self) { index in
                let type = types[index]
                VStack(alignment: .leading) {
                    Text("id : \(type.id)")
                    Text("notionID : \(type.notionID ?? "-")")
                    Text("name : \(type.name)")
                    Text("category : \(type.category)")
                }
            }
            .onDelete(perform: delete)
        }
        .onAppear(perform: load)
        .refreshable {
            load()
        }
        .navigationTitle("Type - CoreData")
        .toolbar {
            ToolbarItem {
                HStack {
                    EditButton()
                    
                    Button {
                        isShowAddScreen = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isShowAddScreen) {
            load()
        } content: {
            AddTypeScreen(typeModel: nil) {
                load()
                isShowAddScreen.toggle()
            }
        }
    }
    
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let type = self.types[index]
            do {
                try CoreDataManager.shared.deleteType(type)
                self.types.remove(at: index)
                load()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func load() {
        CoreDataManager.shared.loadTypes { data in
            self.types = Mapper.mapTypesCoreDataToLocal(data)
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
