//
//  YearMonthPostProperty.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - YearMonthPostProperty
struct YearMonthPostProperty: Codable {
    let name: TitleProperty
    let year, month: SingleSelectProperty
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case year = "Year"
        case month = "Month"
    }
}
