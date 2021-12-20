//
//  YearMonthProperties.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation


// MARK: - Properties
struct YearMonthProperties: Codable {
    let name: Title?
    let month: SingleSelectProperty?
    let year: SingleSelectProperty?
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case month = "Month"
        case year = "Year"
    }
}
