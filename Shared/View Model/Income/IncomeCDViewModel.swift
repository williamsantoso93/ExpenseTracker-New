//
//  IncomeCDViewModel.swift
//  ExpenseTracker
//
//  Created by William Santoso on 09/03/22.
//

import Foundation

class IncomeCDViewModel: ObservableObject {
    let coreDataManager = CoreDataManager.shared
    
    @Published var incomes: [IncomeCD] = []
    
    @Published var searchText = ""
    var incomesFilterd: [IncomeCD] {
        guard !searchText.isEmpty else {
            return incomes
        }
        
        return incomes.filter { result in
            result.keywords.lowercased().contains(searchText.lowercased())
        }
    }
    
    init() {
        loadData()
    }
    
    func loadData() {
        incomes = coreDataManager.getIncomes()
    }
    
    func delete(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let income = incomes[index]
        coreDataManager.deleteIncome(income)
        loadData()
    }
    
    @Published var isShowAddScreen = false
    var selectedIncome: IncomeCD? = nil
    
    func selectIncome(_ income: IncomeCD? = nil) {
        selectedIncome = income
        isShowAddScreen = true
    }
}
