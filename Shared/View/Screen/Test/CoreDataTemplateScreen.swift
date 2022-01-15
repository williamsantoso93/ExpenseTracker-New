//
//  CoreDataTemplateScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 10/01/22.
//

import SwiftUI

struct CoreDataTemplateScreen: View {
    @State private var isShowAddScreen = false
    @State private var templates: [TemplateModel] = []
    
    var body: some View {
        Form {
            ForEach(templates.indices, id:\.self) { index in
                let template = templates[index]
                VStack(alignment: .leading) {
                    Text("notionID : \(template.notionID ?? "")")
                    Text("category : \(template.category ?? "-")")
                    Text("name : \(template.name ?? "-")")
                    Text("store : \(template.store ?? "-")")
                    Text("value : \(template.value ?? 0)")
                    Text("duration : \(template.duration ?? "-")")
                    Text("paymentVia : \(template.paymentVia ?? "-")")
                    if let types = template.types {
                        Text("types : \(types.joinedWithComma())")
                    }
                }
            }
            .onDelete(perform: delete)
        }
        .onAppear(perform: load)
        .refreshable {
            load()
        }
        .navigationTitle("Template - CoreData")
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
            AddTemplatescreen(templateModel: nil) {
                load()
                isShowAddScreen.toggle()
            }
        }
    }
    
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let template = self.templates[index]
            do {
                try CoreDataManager.shared.deleteTemplate(template)
                self.templates.remove(at: index)
                load()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func load() {
        CoreDataManager.shared.loadTempalates { data in
            self.templates = Mapper.mapTemplatesCoreDataToLocal(data)
        }
    }
}

struct CoreDataTemplateScreen_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataTemplateScreen()
    }
}
