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
    let month: SingleSelectProperty
    let year: SingleSelectProperty
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case month = "Month"
        case year = "Year"
    }
}

// MARK: - YearMonthQuery
struct YearMonthQuery: Codable {
    let sorts: [Sort]?
}
