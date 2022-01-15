//
//  ExpenseModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - ExpenseModel
struct ExpenseModel: Codable {
    var id: String = UUID().uuidString
    var notionID: String?
    var yearMonth: String?
    var yearMonthID: String? = nil
    var value: Int?
    var duration, paymentVia, store: String?
    var types: [String]?
    var note: String?
    var date: Date?
    var keywords: String?
}
