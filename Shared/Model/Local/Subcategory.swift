//
//  Subcategory.swift
//  ExpenseTracker
//
//  Created by William Santoso on 27/02/22.
//

import Foundation

struct Subcategory: Codable {
    var id: UUID = UUID()
    let name: String
    var expenses: [Expense] = []
    var incomes: [Income] = []
    var mainCategory: Category? = nil
}
