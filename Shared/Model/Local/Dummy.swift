//
//  Dummy.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 15/01/22.
//

import Foundation

struct Dummy {
    static let yearMonth = YearMonthModel(id: UUID().uuidString, notionID: UUID().uuidString, name: "2022/01 January", month: "01 January", year: "2022", totalIncomes: nil, totalExpenses: nil)
    static let expense = ExpenseModel(id: UUID().uuidString, notionID: UUID().uuidString, yearMonth: "2022/01 January", yearMonthID: UUID().uuidString, value: 100000, duration: "Once", paymentVia: "CC BCA", store: "Food Hall", types: ["Dummy", "Food"], note: "Test Dummy note", date: Date(), keywords: nil)
    static let income = IncomeModel(id: UUID().uuidString, notionID: UUID().uuidString, yearMonth: "2022/01 January", yearMonthID: UUID().uuidString, value: 100000, types: ["Dummy", "Food"], note: "Test Dummy note", date: Date(), keywords: nil)
}
