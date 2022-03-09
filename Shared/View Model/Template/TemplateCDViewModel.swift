//
//  TemplateCDViewModel.swift
//  ExpenseTracker
//
//  Created by William Santoso on 09/03/22.
//

import Foundation

class TemplateCDViewModel: ObservableObject {
    let coreDataManager = CoreDataManager.shared
    @Published var templateModels: [TemplateModelCD]  = []
    
    @Published var searchText = ""
    func filterTemplate(_ category: String) -> [TemplateModelCD] {
        let templateModels = templateModels.filter { result in
            result.type.lowercased() == category.lowercased()
        }
        guard !searchText.isEmpty else {
            return templateModels
        }
        
        return templateModels.filter { result in
            result.keywords.lowercased().contains(searchText.lowercased())
        }
        
    }
    
    var category: [String] {
        [
            "income",
            "expense",
        ]
    }
    
    init() {
        loadData()
    }
    
    func loadData() {
        templateModels = coreDataManager.getTemplateModels()
        print(templateModels)
    }
    
    func delete(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let templateModel = templateModels[index]
        coreDataManager.deleteTemplateModel(templateModel)
        loadData()
    }
    
    @Published var isShowAddScreen = false
    var selectedTemplate: TemplateModelCD? = nil
    
    func selectTemplate(_ template: TemplateModelCD? = nil) {
        selectedTemplate = template
        isShowAddScreen = true
    }
}
