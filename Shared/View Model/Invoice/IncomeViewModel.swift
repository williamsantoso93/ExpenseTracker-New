//
//  IncomeViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

class IncomeViewModel: ObservableObject {
    @Published var incomes: [Income] = []
    var startCursor: String? = nil
    
    init() {
        loadNewData()
    }
    
    func loadNewData() {
        incomes.removeAll()
        startCursor = nil
        getList { incomes in
            self.incomes = incomes
        }
    }
    
    func getList(startCursor: String? = nil, completion: @escaping ([Income]) -> Void) {
        Networking.shared.getIncome(startCursor: startCursor) { (result: Result<DefaultResponse<IncomeProperty>, NetworkError>) in
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
                    return completion(Mapper.mapIncomeRemoteToLocal(data.results))
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func loadMoreList(of index: Int) {
        guard index < incomes.count else { return }
        guard index == incomes.count - 2 else { return }
               
        guard startCursor != nil else { return }
        
        getList { incomes in
            self.incomes.append(contentsOf: incomes)
        }
    }
}
