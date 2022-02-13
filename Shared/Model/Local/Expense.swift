//
//  Expense.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - Expense
struct Expense: Codable {
    var blockID: String
    var id: String = UUID().uuidString
    var yearMonth: String?
    var yearMonthID: String? = nil
    var note: String?
    var value: Double?
    var account, category, subcategory, duration, paymentVia, store: String?
    var date: Date?
    var keywords: String?
}
