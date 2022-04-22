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
    let label, account, category, subcategory, duration, payment: SingleSelectProperty?
    let store: RichTextProperty?
    let date: DateProperty?
    var keywords: FormulaProperty? = nil
    var isDoneExport: CheckmarkProperty?
    
    enum CodingKeys: String, CodingKey {
        case yearMonth = "Year/Month"
        case account = "Account"
        case note = "Note"
        case id
        case value = "Value"
        case label = "Label"
        case duration = "Duration"
        case payment = "Payment"
        case store = "Store"
        case date = "Date"
        case category = "Category"
        case subcategory = "Subcategory"
        case keywords = "Keywords"
        case isDoneExport = "Done Export"
    }
}
