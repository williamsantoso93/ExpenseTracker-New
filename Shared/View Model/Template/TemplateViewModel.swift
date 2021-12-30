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
    
    
    func filterTemplate(_ category: String) -> [TemplateModel] {
        globalData.templateModels.filter { result in
            result.category == category.capitalized
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
