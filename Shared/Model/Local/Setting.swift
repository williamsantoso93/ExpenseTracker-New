//
//  Setting.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

// MARK: - TemplateModel
struct TemplateModel: Codable, Hashable {
    var blockID: String
    var name: String?
    var category, duration, paymentVia, type: String?
    var value: Int?
}