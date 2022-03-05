//
//  OthersViewModel.swift
//  ExpenseTracker
//
//  Created by William Santoso on 01/03/22.
//

import Foundation

class OthersViewModel: ObservableObject {
    let coreDataManager = CoreDataManager.shared
    
    @Published var labels: [LabelModel] = []
    @Published var accounts: [Account] = []
    @Published var categories: [Category] = []
    @Published var categoryNatures: [CategoryNature] = []
    @Published var subcategories: [Subcategory] = []
    @Published var durations: [Duration] = []
    @Published var payments: [Payment] = []
    @Published var stores: [Store] = []
    @Published var incomes: [IncomeCD] = []
    @Published var expenes: [ExpenseCD] = []
    @Published var templates: [TemplateModelCD] = []
    
    init() {
        getData()
    }
    
    func getData() {
        labels = coreDataManager.getLabels()
        accounts = coreDataManager.getAccounts()
        categories = coreDataManager.getCategories()
        categoryNatures = coreDataManager.getCategoryNatures()
        subcategories = coreDataManager.getSubcategories()
        durations = coreDataManager.getDurations()
        payments = coreDataManager.getPayments()
        stores = coreDataManager.getStores()
        incomes = coreDataManager.getIncomes()
        expenes = coreDataManager.getExpenes()
        templates = coreDataManager.getTemplateModels()
    }
    
    func deleteAccount(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let account = accounts[index]
        coreDataManager.deleteAccount(account)
        getData()
    }
    
    func deleteCategory(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let category = categories[index]
        coreDataManager.deleteCategory(category)
        getData()
    }
    
    func deleteSubcategory(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let subcategory = subcategories[index]
        coreDataManager.deleteSubcategory(subcategory)
        getData()
    }
    
    func deleteCategoryNature(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let categoryNature = categoryNatures[index]
        coreDataManager.deleteCategoryNature(categoryNature)
        getData()
    }
}
