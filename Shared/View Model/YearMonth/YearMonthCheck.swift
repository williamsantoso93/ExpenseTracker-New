//
//  YearMonthCheck.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 25/12/21.
//

import Foundation
import Combine

class YearMonthCheck {
    static let shared = YearMonthCheck()
    
    let globalData = GlobalData.shared
    
    var cancellables = Set<AnyCancellable>()
        
    func getYearMonthID(_ date: Date, completion: @escaping (String) -> Void) {
        let yearMonth = globalData.yearMonths.filter { result in
            result.name == date.toYearMonthString()
        }
        
        if let id = yearMonth.first?.id {
            return completion(id)
        } else {
            addYearMonth(date) { id in
                return completion(id)
            }
        }
    }
    
    func addYearMonth(_ date: Date, completion: @escaping (String) -> Void) {
        let name = date.toYearMonthString()
        let month = date.toString(format: "MM MMMM")
        let year = date.toString(format: "yyyy")
        
        let yearMonth = YearMonth(
            id: "",
            name: name,
            month: month,
            year: year
        )
        
        Networking.shared.postYearMonth(yearMonth)
            .sink { _ in
            } receiveValue: { isSuccess in
                self.globalData.getYearMonth {
                    self.getYearMonthID(date) { id in
                        return completion(id)
                    }
                }
            }
            .store(in: &self.cancellables)
    }
}
