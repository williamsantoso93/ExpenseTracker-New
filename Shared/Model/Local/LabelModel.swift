//
//  LabelModel.swift
//  ExpenseTracker
//
//  Created by William Santoso on 27/02/22.
//

import Foundation

struct LabelModel: Codable {
    var id: UUID = UUID()
    var name: String
    var expenses: [Expense] = []
    var incomes: [Income] = []
}
