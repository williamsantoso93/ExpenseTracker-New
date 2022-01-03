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
    let category, duration, paymentVia, type: SingleSelectProperty?
    let value: NumberProperty?
    var keywords: FormulaProperty? = nil
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case category = "Category"
        case duration = "Duration"
        case paymentVia = "Payment Via"
        case type = "Type"
        case value = "Value"
        case keywords = "Keywords"
    }
}
