//
//  Expense.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - Expense
struct Expense: Codable {
    var id: String = UUID().uuidString
    var yearMonth: String?
    var note: String?
    var value: Int?
    var duration, paymentVia, type: String?
    var date: Date?
}
