//
//  ExpenseProperty.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - ExpenseProperty
struct ExpenseProperty: Codable {
    let id: TitleProperty?
    let yearMonth: RelationProperty?
    let note: RichTextProperty?
    let value: NumberProperty?
    let duration, paymentVia : SingleSelectProperty?
    let types : MultiSelectProperty?
    let date: DateProperty?
    
    enum CodingKeys: String, CodingKey {
        case yearMonth = "Year/Month"
        case note = "Note"
        case id
        case value = "Value"
        case duration = "Duration"
        case paymentVia = "Payment Via"
        case date = "Date"
        case types = "Types"
    }
}
