//
//  YearMonthModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

struct YearMonthModel {
    var id: String = UUID().uuidString
    var notionID: String?
    var name, month, year: String
    var totalIncomes: Int? = nil
    var totalExpenses: Int? = nil
}
