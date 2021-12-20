//
//  IncomePostProperty.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - IncomePostProperty
struct IncomePostProperty: Codable {
    let id: TitleProperty
    let yearMonth: RelationProperty
    let type: SingleSelectProperty
    let value: NumberProperty
    let note: RichTextProperty
    
    enum CodingKeys: String, CodingKey {
        case id
        case yearMonth = "Year/Month"
        case type = "Type"
        case value = "Value"
        case note = "Note"
    }
}
