//
//  CoreDataTemplateScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 10/01/22.
//

import SwiftUI

class CoreDataTemplateViewModel: ObservableObject {
    @Published var globalData = GlobalData.shared
    @Published var isShowAddScreen = false
    var selectedTemplate: TemplateModel? = nil
    
    @Published var searchText = ""
    func filterTemplate(_ category: String) -> [TemplateModel] {
        let templateModels = globalData.templateModels.filter { result in
            result.category == category.capitalized
        }
        guard !searchText.isEmpty else {
            return templateModels
        }
        
        return templateModels.filter { result in
            result.keywords?.lowercased().contains(searchText.lowercased()) ?? false
        }
        
    }
    
    var category: [String] {
        [
            "Income",
            "Expense",
        ]
    }
    
    func delete(_ templateModels: [TemplateModel], at offsets: IndexSet) {
        offsets.forEach { index in
            let template = templateModels[index]
            do {
                try CoreDataManager.shared.deleteTemplate(template)
                
                if let templateIndex = getTemplatesModelsIndex(from: template.id) {
                    self.globalData.templateModels.remove(at: templateIndex)
                    globalData.getTemplateModelCoreData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getTemplatesModelsIndex(from id: String) -> Int? {
        globalData.templateModels.firstIndex { result in
            result.id == id
        }
    }
    
    func selectTemplate(_ template: TemplateModel? = nil) {
        selectedTemplate = template
        isShowAddScreen = true
    }
}

struct CoreDataTemplateScreen: View {
    @ObservedObject var globalData = GlobalData.shared
    
    @StateObject var viewModel = CoreDataTemplateViewModel()
    
    var body: some View {
        Form {
            if !globalData.templateModels.isEmpty {
                ForEach(viewModel.category, id:\.self) { category in
                    let templateModels = viewModel.filterTemplate(category)
                    
                    Section(header: Text(category)) {
                        ForEach(templateModels.indices, id:\.self) { index in
                            let template = templateModels[index]
                            
                            Button {
                                viewModel.selectTemplate(template)
                            } label: {
                                TemplateCellView(template: template)
                            }
                        }
                        .onDelete { offsets in
                            viewModel.delete(templateModels, at: offsets)
                        }
                    }
                }
            }
        }
        .onAppear(perform: globalData.getTemplateModelCoreData)
        .refreshable {
            globalData.getTemplateModelCoreData()
        }
        .navigationTitle("Template - CoreData")
        .toolbar {
            ToolbarItem {
                HStack {
                    EditButton()
                    
                    Button {
                        viewModel.selectTemplate()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowAddScreen) {
            viewModel.selectedTemplate = nil
        } content: {
            AddTemplatescreen(templateModel: viewModel.selectedTemplate) {
                globalData.getTemplateModelCoreData()
                viewModel.isShowAddScreen.toggle()
            }
        }
    }
}

struct CoreDataTemplateScreen_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataTemplateScreen()
    }
}
