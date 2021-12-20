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
        let urlString = Networking.shared.baseDatabase + Networking.DatabaseID.expenseDatabaseID.rawValue + "/query"
        
        let post = Query(
            startCursor: startCursor,
            pageSize: 5,
            sorts: [
                Sort(property: "id", direction: Networking.SortDirection.ascending.rawValue)
            ]
        )
        
        Networking.shared.postData(to: urlString, postData: post) { (result: Result<DefaultResponse<ExpenseProperty>, NetworkError>, response, dataResponse, isSuccess) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.expenses = Mapper.mapExpenseRemoteToLocal(data.results)
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
