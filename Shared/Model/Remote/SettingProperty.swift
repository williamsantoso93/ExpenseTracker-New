//
//  SettingProperty.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

// MARK: - TemplateExpenseProperty
struct TemplateExpenseProperty: Codable {
    let name: TitleProperty?
    let duration, paymentVia, type: SingleSelectProperty?
    let value: NumberProperty?
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case duration = "Duration"
        case paymentVia = "Payment Via"
        case type = "Type"
        case value = "Value"
    }
}
