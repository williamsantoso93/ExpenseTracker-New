//
//  SettingProperty.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

// MARK: - TemplateModelProperty
struct TemplateModelProperty: Codable {
    let name: TitleProperty?
    let label, account, category, subcategory: SingleSelectProperty?
    let type, duration, payment: SingleSelectProperty?
    let value: NumberProperty?
    let store: RichTextProperty?
    var keywords: FormulaProperty? = nil
    var isDoneExport: CheckmarkProperty?
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case duration = "Duration"
        case type = "Type"
        case label = "Label"
        case payment = "Payment"
        case account = "Account"
        case category = "Category"
        case subcategory = "Subcategory"
        case store = "Store"
        case value = "Value"
        case keywords = "Keywords"
        case isDoneExport = "Done Export"
    }
}
