//
//  YearMonthViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

import Foundation

class YearMonthViewModel: ObservableObject {
    @Published var yearMonths: [YearMonth] = GlobalData.shared.yearMonths
    var startCursor: String? = nil
    
    init() {
//        loadNewData()
    }
    
    func loadNewData() {
        yearMonths.removeAll()
        startCursor = nil
        getList { yearMonths in
            self.yearMonths = yearMonths
        }
    }
    
    func getList(completion: @escaping ([YearMonth]) -> Void) {
        let urlString = Networking.shared.baseDatabase + Networking.DatabaseID.yearMonthDatabaseID.rawValue + "/query"
        
        let post = Query(
            startCursor: startCursor,
            pageSize: 5,
            sorts: [
                Sort(property: "Name", direction: Networking.SortDirection.ascending.rawValue)
            ]
        )
        Networking.shared.postData(to: urlString, postData: post) { (result: Result<DefaultResponse<YearMonthProperty>, NetworkError>, response, dataResponse, isSuccess) in
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
                    return completion(Mapper.mapYearMonthListRemoteToLocal(data.results))
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func loadMoreList(of index: Int) {
        guard index < yearMonths.count else { return }
        guard index == yearMonths.count - 2 else { return }
        
        guard startCursor != nil else { return }
        
        getList { yearMonths in
            self.yearMonths.append(contentsOf: yearMonths)
        }
    }
}
