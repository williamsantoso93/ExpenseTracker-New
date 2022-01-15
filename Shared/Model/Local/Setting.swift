//
//  Setting.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

// MARK: - TemplateModel
struct TemplateModel: Codable, Hashable {
    var notionID: String?
    var id: String = UUID().uuidString
    var name: String?
    var category, duration, paymentVia, store: String?
    var types: [String]?
    var value: Int?
    var keywords: String?
}
