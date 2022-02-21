//
//  ExpenseViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation
import Combine

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    var startCursor: String? = nil
    @Published var isLoading = false
    var isNowShowData: Bool {
        expenses.isEmpty
    }
    var cancelables = Set<AnyCancellable>()
    
    init() {
        loadNewData()
    }
    
    @Published var searchText = ""
    var expensesFilterd: [Expense] {
        guard !searchText.isEmpty else {
            return expenses
        }
        
        return expenses.filter { result in
            result.keywords?.lowercased().contains(searchText.lowercased()) ?? false
        }
    }
    
    func loadNewData() {
        startCursor = nil
        getList { expenses in
            self.expenses = expenses
        }
    }
    
    func getList(completion: @escaping ([Expense]) -> Void) {
        isLoading = true
        do {
            try Networking.shared.getExpense(startCursor: startCursor)
                .sink { completion in
                    self.isLoading = false
                } receiveValue: { data in
                    if data.hasMore {
                        if let nextCursor = data.nextCursor {
                            self.startCursor = nextCursor
                        }
                    } else {
                        self.startCursor = nil
                    }
                    return completion(Mapper.mapExpenseRemoteToLocal(data.results))
                }
                .store(in: &self.cancelables)
        } catch {
            print(error)
        }
    }
    
    func loadMoreList(of index: Int) {
        guard index < expenses.count else { return }
        guard index == expenses.count - 2 else { return }
        
        guard startCursor != nil else { return }
        
        getList { expenses in
            self.expenses.append(contentsOf: expenses)
        }
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let id = self.expenses[index].blockID
            isLoading = true
            
            do {
                try Networking.shared.delete(id: id)
                    .sink { _ in
                        self.isLoading = false
                    } receiveValue: { isSuccess in
                        if isSuccess {
                            self.expenses.remove(at: index)
                        }
                    }
                    .store(in: &self.cancelables)
            } catch {
                print(error)
            }
        }
    }
    
    @Published var isShowAddScreen = false
    var selectedExpense: Expense? = nil
    
    func selectExpense(_ expense: Expense? = nil) {
        selectedExpense = expense
        isShowAddScreen = true
    }
}
