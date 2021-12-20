//
//  ExpensePostProperty.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - Properties
struct ExpensePostProperty: Codable {
    let id: TitleProperty?
    let yearMonth: RelationProperty?
    let type, duration: SingleSelectProperty?
    let value: NumberProperty?
    let paymentVia: SingleSelectProperty?
    let date: DateProperty?
    let note: RichText?
    
    enum CodingKeys: String, CodingKey {
        case id
        case yearMonth = "Year/Month"
        case type = "Type"
        case duration = "Duration"
        case value = "Value"
        case paymentVia = "Payment Via"
        case date = "Date"
        case note = "Note"
    }
}
