//
//  YearMonthViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

import Foundation

class YearMonthViewModel: ObservableObject {
    var yearMonths: [YearMonth] = []
    
    var incomes: [Income] {
        get {
            GlobalData.shared.incomes
        }
        set {
            updateYearMonth()
        }
    }
    
    var expenses: [Expense] {
        get {
            GlobalData.shared.expenses
        }
        set {
            updateYearMonth()
        }
    }
    
    func updateYearMonth() {
//        let yearMonths = GlobalData.shared.yearMonths.map { yearMonth in
//            var yearMonth = yearMonth
//            let totalIncomes: Double = incomes.map { income in
//                if income.yearMonth == yearMonth.name {
//                    return income.value ?? 0
//                }
//                return 0
//            }.reduce(0, +)
//            let totalExpenses: Double = expenses.map { expense in
//                if expense.yearMonth == yearMonth.name {
//                    return expense.value ?? 0
//                }
//                return 0
//            }.reduce(0, +)
//            
//            yearMonth.totalIncomes = totalIncomes
//            yearMonth.totalExpenses = totalExpenses
//            
//            return yearMonth
//        }
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
