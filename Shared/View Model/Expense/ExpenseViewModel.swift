//
//  ExpenseViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [ExpenseModel] = []
    var startCursor: String? = nil
    @Published var isLoading = false
    var isNowShowData: Bool {
        expenses.isEmpty
    }
    
    init() {
        loadNewData()
    }
    
    @Published var searchText = ""
    var expensesFilterd: [ExpenseModel] {
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
    
    func getList(completion: @escaping ([ExpenseModel]) -> Void) {
        isLoading = true
        Networking.shared.getExpense(startCursor: startCursor) { (result: Result<DefaultResponse<ExpenseProperty>, NetworkError>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if data.hasMore {
                        if let nextCursor = data.nextCursor {
                            self.startCursor = nextCursor
                        }
                    } else {
                        self.startCursor = nil
                    }
                    return completion(Mapper.mapExpenseRemoteToLocal(data.results))
                case .failure(let error):
                    print(error)
                }
            }
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
            guard let id = self.expenses[index].notionID else { return }
            
            Networking.shared.delete(id: id) { isSuccess in
                if isSuccess {
                    self.expenses.remove(at: index)
                }
            }
        }
    }
    
    @Published var isShowAddScreen = false
    var selectedExpense: ExpenseModel? = nil
    
    func selectExpense(_ expenseModel: ExpenseModel? = nil) {
        selectedExpense = expenseModel
        isShowAddScreen = true
    }
}
