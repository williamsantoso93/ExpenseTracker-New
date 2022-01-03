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
    @Published var isLoading = false
    var isNowShowData: Bool {
        incomes.isEmpty
    }
    
    init() {
        loadNewData()
    }
    
    @Published var searchText = ""
    var incomesFilterd: [Income] {
        guard !searchText.isEmpty else {
            return incomes
        }
        
        return incomes.filter { result in
            result.keywords?.lowercased().contains(searchText.lowercased()) ?? false
        }
    }
    
    func loadNewData() {
        startCursor = nil
        getList { incomes in
            self.incomes = incomes
        }
    }
    
    func getList(startCursor: String? = nil, completion: @escaping ([Income]) -> Void) {
        isLoading = true
        Networking.shared.getIncome(startCursor: startCursor) { (result: Result<DefaultResponse<IncomeProperty>, NetworkError>) in
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
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let id = self.incomes[index].blockID
            
            Networking.shared.delete(id: id) { isSuccess in
                if isSuccess {
                    self.incomes.remove(at: index)
                }
            }
        }
    }
        
    @Published var isShowAddScreen = false
    var selectedIncome: Income? = nil
    
    func selectIncome(_ income: Income? = nil) {
        selectedIncome = income
        isShowAddScreen = true
    }
}
