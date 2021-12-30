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
        let yearMonths: [YearMonth]
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
            let yearMonths = getYearMonths(year: year)
            displayYearMonths.append(DisplayYearMonth(year: year, yearMonths: yearMonths))
        }
        
        return displayYearMonths.sorted {
            $0.year < $1.year
        }
    }
    
    func getYearMonths(year: String) -> [YearMonth] {
        let filteredYearMonths = yearMonths.filter { result in
            result.year == year
        }
        
        return filteredYearMonths
    }
}
