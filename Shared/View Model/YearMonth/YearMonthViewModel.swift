//
//  YearMonthViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

import Foundation

class YearMonthViewModel: ObservableObject {
    var yearMonths: [YearMonth] {
        GlobalData.shared.yearMonths
    }
    
    struct DisplayYearMonth {
        let year: String
        let months: [String]
    }
    
    var years: [String] {
        let years = yearMonths.map { result in
            result.year
        }
        return Array(Set(years))
    }
    
    var displayYearMonths: [DisplayYearMonth] {
        var displayYearMonths = [DisplayYearMonth]()
        
        for year in years {
            let months = getMonths(year: year)
            displayYearMonths.append(DisplayYearMonth(year: year, months: months))
        }
        
        return displayYearMonths
    }
    
    func getMonths(year: String) -> [String] {
        let filteredYearMonths = yearMonths.filter { result in
            result.year == year
        }
        
        return filteredYearMonths.map { result in
            result.month
        }
    }
}
