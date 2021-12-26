//
//  Setting.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

// MARK: - TemplateExpense
struct TemplateExpense: Codable, Hashable {
    var blockID: String
    var name: String?
    var duration, paymentVia, type: String?
    var value: Int?
}
