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
    var label: String?
    var account: String?
    var category: String?
    var subcategory: String?
    var note: String?
    var date: Date?
    var keywords: String?
}

struct IncomeCD: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var note: String?
    var value: Double = 0
    var label: LabelModel?
    var account: Account?
    var category: Category?
    var subcategory: Subcategory?
    var date: Date = Date()
    var dateCreated: Date = Date()
    var dateUpdated: Date = Date()
    
    var keywords: String {
        [
            note ?? "" ,
            "\(value)",
            account?.name ?? "" ,
            category?.name ?? "" ,
            subcategory?.name ?? "" ,
            label?.name ?? "" ,
            label?.name ?? "" ,
            date.toString(),
            dateCreated.toString(),
            dateUpdated.toString(),
        ].joinedWithComma()
    }
}
