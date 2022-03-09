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
    @Published var expenses: [ExpenseCD] = []
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
        expenses = coreDataManager.getExpenses()
        templates = coreDataManager.getTemplateModels()
    }
    
    func deleteLabel(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let label = labels[index]
        coreDataManager.deleteLabel(label)
        getData()
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
    
    func deleteDuration(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let duration = durations[index]
        coreDataManager.deleteDuration(duration)
        getData()
    }
    
    func deletePayment(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let payment = payments[index]
        coreDataManager.deletePayment(payment)
        getData()
    }
    
    func deleteStore(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let store = stores[index]
        coreDataManager.deleteStore(store)
        getData()
    }
    
    //MARK: - Label
    @Published var isShowAddLabelScreen = false
    @Published var selectedLabelModel: LabelModel? = nil
    
    func selectLabel(_ local: LabelModel? = nil) {
        selectedLabelModel = local
        isShowAddLabelScreen = true
    }
    
    //MARK: - Account
    @Published var isShowAddAccountScreen = false
    @Published var selectedAccount: Account? = nil
    
    func selectAccount(_ local: Account? = nil) {
        selectedAccount = local
        isShowAddAccountScreen = true
    }
    
    
    //MARK: - Category
    @Published var isShowAddCategoryScreen = false
    @Published var selectedCategory: Category? = nil
    
    func selectCategory(_ local: Category? = nil) {
        selectedCategory = local
        isShowAddCategoryScreen = true
    }
    
    //MARK: - CategoryNature
    @Published var isShowAddCategoryNatureScreen = false
    @Published var selectedCategoryNature: CategoryNature? = nil
    
    func selectCategoryNature(_ local: CategoryNature? = nil) {
        selectedCategoryNature = local
        isShowAddCategoryNatureScreen = true
    }
    
    //MARK: - Subcategory
    @Published var isShowAddSubcategoryScreen = false
    @Published var selectedSubcategory: Subcategory? = nil
    
    func selectSubcategory(_ local: Subcategory? = nil) {
        selectedSubcategory = local
        isShowAddSubcategoryScreen = true
    }
    
    //MARK: - Duration
    @Published var isShowAddDurationScreen = false
    @Published var selectedDuration: Duration? = nil
    
    func selectDuration(_ local: Duration? = nil) {
        selectedDuration = local
        isShowAddDurationScreen = true
    }
    
    //MARK: - Payment
    @Published var isShowAddPaymentScreen = false
    @Published var selectedPayment: Payment? = nil
    
    func selectPayment(_ local: Payment? = nil) {
        selectedPayment = local
        isShowAddPaymentScreen = true
    }
    
    //MARK: - Store
    @Published var isShowAddStoreScreen = false
    @Published var selectedStore: Store? = nil
    
    func selectStore(_ local: Store? = nil) {
        selectedStore = local
        isShowAddStoreScreen = true
    }
}
