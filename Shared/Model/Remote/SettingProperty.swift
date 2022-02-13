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
    let account, category, subcategory: SingleSelectProperty?
    let type, duration, paymentVia: SingleSelectProperty?
    let value: NumberProperty?
    let store: RichTextProperty?
    var keywords: FormulaProperty? = nil
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case duration = "Duration"
        case type = "Type"
        case paymentVia = "Payment Via"
        case account = "Account"
        case category = "Category"
        case subcategory = "Subcategory"
        case store = "Store"
        case value = "Value"
        case keywords = "Keywords"
    }
}
