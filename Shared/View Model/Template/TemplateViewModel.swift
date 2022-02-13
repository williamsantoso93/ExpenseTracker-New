//
//  TemplateViewModel.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

class TemplateViewModel: ObservableObject {
    @Published var globalData = GlobalData.shared
    @Published var isLoading = false
    
    @Published var searchText = ""
    func filterTemplate(_ category: String) -> [TemplateModel] {
        let templateModels = globalData.templateModels.filter { result in
            result.type == category.capitalized
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
    
    @Published var isShowAddScreen = false
    var selectedTemplate: TemplateModel? = nil
    
    func selectTemplate(_ template: TemplateModel? = nil) {
        selectedTemplate = template
        isShowAddScreen = true
    }
}
