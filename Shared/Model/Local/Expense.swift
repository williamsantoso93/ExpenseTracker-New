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
    var label, account, category, subcategory, duration, payment, store: String?
    var date: Date?
    var keywords: String?
}

struct ExpenseCD: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var note: String?
    var value: Double = 0
    var label: LabelModel?
    var account: Account?
    var category: Category?
    var subcategory: Subcategory?
    var duration: Duration?
    var payment: Payment?
    var store: String?
    var date: Date = Date()
    var dateCreated: Date = Date()
    var dateUpdated: Date = Date()
    
    var keywords: String {
        [
            note ?? "",
            "\(value)",
            label?.name ?? "",
            account?.name ?? "",
            category?.name ?? "",
            subcategory?.name ?? "",
            duration?.name ?? "",
            store ?? "",
            date.toStringFull(),
            dateCreated.toStringFull(),
            dateUpdated.toStringFull(),
        ].joinedWithComma()
    }
}
