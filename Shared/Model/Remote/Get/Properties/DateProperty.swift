//
//  DateProperty.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - DateProperty
struct DateProperty: Codable {
    let date: DateModel
}

// MARK: - DateModel
struct DateModel: Codable {
    let start: String
    
    enum CodingKeys: String, CodingKey {
        case start
    }
}
