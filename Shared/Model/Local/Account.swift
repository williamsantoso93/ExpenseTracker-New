//
//  Account.swift
//  ExpenseTracker
//
//  Created by William Santoso on 27/02/22.
//

import Foundation

struct Account: Codable {
    var id: UUID = UUID()
    let name: String
    var expenses: [Expense] = []
    var incomes: [Income] = []
}
