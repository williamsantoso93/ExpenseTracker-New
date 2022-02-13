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
    let account, category, subcategory, duration, paymentVia: SingleSelectProperty?
    let store: RichTextProperty?
    let date: DateProperty?
    var keywords: FormulaProperty? = nil
    
    enum CodingKeys: String, CodingKey {
        case yearMonth = "Year/Month"
        case account = "Account"
        case note = "Note"
        case id
        case value = "Value"
        case duration = "Duration"
        case paymentVia = "Payment Via"
        case store = "Store"
        case date = "Date"
        case category = "Category"
        case subcategory = "Subcategory"
        case keywords = "Keywords"
    }
}
