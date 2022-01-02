//
//  SelectProperty.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - SingleSelectProperty
struct SingleSelectProperty: Codable {
    let select: Select?
}

// MARK: - MultiSelectProperty
struct MultiSelectProperty: Codable {
    var multiSelect: [Select]?
    
    enum CodingKeys: String, CodingKey {
        case multiSelect = "multi_select"
    }
}

// MARK: - Select
struct Select: Codable {
    let name: String
}
