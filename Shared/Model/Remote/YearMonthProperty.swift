//
//  YearMonthProperty.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - YearMonthProperty
struct YearMonthProperty: Codable {
    let name: TitleProperty
    let month, year: SingleSelectProperty
    let totalIncomes, totalExpenses: RoolupProperty<NumberProperty>?
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case month = "Month"
        case year = "Year"
        case totalIncomes = "Total Incomes"
        case totalExpenses = "Total Expenses"
    }
}

