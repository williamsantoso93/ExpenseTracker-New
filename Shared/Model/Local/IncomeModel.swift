//
//  IncomeModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - IncomeModel
struct IncomeModel: Codable {
    var notionID: String?
    var id: String = UUID().uuidString
    var yearMonth: String?
    var yearMonthID: String? = nil
    var value: Int?
    var types: [String]?
    var note: String?
    var date: Date?
    var keywords: String?
}
