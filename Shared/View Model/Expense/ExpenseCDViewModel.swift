//
//  ExpenseCDViewModel.swift
//  ExpenseTracker
//
//  Created by William Santoso on 09/03/22.
//

import Foundation

class ExpenseCDViewModel: ObservableObject {
    let coreDataManager = CoreDataManager.shared
    @Published var expenses: [ExpenseCD] = []
    
    @Published var searchText = ""
    var expensesFilterd: [ExpenseCD] {
        guard !searchText.isEmpty else {
            return expenses
        }
        
        return expenses.filter { result in
            result.keywords.lowercased().contains(searchText.lowercased())
        }
    }
    
    init() {
        loadData()
    }
    
    func loadData() {
        expenses = coreDataManager.getExpenses()
    }
    
    func delete(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let expense = expenses[index]
        coreDataManager.deleteExpense(expense)
        loadData()
    }
    
    @Published var isShowAddScreen = false
    var selectedExpense: ExpenseCD? = nil
    
    func selectExpense(_ expense: ExpenseCD? = nil) {
        selectedExpense = expense
        isShowAddScreen = true
    }
}
