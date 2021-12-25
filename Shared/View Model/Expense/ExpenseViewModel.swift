//
//  ExpenseViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    var startCursor: String? = nil
    
    init() {
        loadNewData()
    }
    
    func loadNewData() {
        expenses.removeAll()
        startCursor = nil
        getList { expenses in
            self.expenses = expenses
        }
    }
    
    func getList(completion: @escaping ([Expense]) -> Void) {
        Networking.shared.getExpense(startCursor: startCursor) { (result: Result<DefaultResponse<ExpenseProperty>, NetworkError>) in
            DispatchQueue.main.async {
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
}
