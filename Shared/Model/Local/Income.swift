//
//  Income.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - Income
struct Income: Codable {
    var blockID: String
    var id: String = UUID().uuidString
    var yearMonth: String?
    var yearMonthID: String? = nil
    var value: Double?
    var types: [String]?
    var note: String?
    var date: Date?
    var keywords: String?
}
