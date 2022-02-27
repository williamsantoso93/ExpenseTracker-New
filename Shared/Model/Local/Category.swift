//
//  Category.swift
//  ExpenseTracker
//
//  Created by William Santoso on 27/02/22.
//

import Foundation

struct Category: Codable {
    var id: UUID = UUID()
    let name: String
    let type: String
    var expenses: [Expense] = []
    var incomes: [Income] = []
    var nature: CategoryNature? = nil
    var subcategoryOf: [Subcategory] = []
}
