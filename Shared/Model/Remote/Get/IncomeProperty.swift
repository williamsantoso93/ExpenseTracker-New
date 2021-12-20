//
//  IncomeProperty.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - IncomeProperty
struct IncomeProperty: Codable {
    let id: Title?
    let yearMonth: RelationProperty?
    let value: NumberProperty?
    let type: SingleSelectProperty?
    let note: RichText?
    
    enum CodingKeys: String, CodingKey {
        case yearMonth = "Year/Month"
        case type = "Type"
        case note = "Note"
        case value = "Value"
        case id
    }
}
