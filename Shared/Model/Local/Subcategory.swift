//
//  Subcategory.swift
//  ExpenseTracker
//
//  Created by William Santoso on 27/02/22.
//

import Foundation

struct Subcategory: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var dateCreated: Date = Date()
    var dateUpdated: Date = Date()
    var expenses: [ExpenseCD] = []
    var incomes: [IncomeCD] = []
    var mainCategory: Category? = nil
}
