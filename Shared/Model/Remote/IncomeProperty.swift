//
//  IncomeProperty.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - IncomeProperty
struct IncomeProperty: Codable {
    let id: TitleProperty?
    let yearMonth: RelationProperty?
    let value: NumberProperty?
    let type: SingleSelectProperty?
    let note: RichTextProperty?
    let date: DateProperty?
    var keywords: FormulaProperty? = nil
    
    enum CodingKeys: String, CodingKey {
        case yearMonth = "Year/Month"
        case type = "Type"
        case note = "Note"
        case value = "Value"
        case date = "Date"
        case id
        case keywords = "Keywords"
    }
}
