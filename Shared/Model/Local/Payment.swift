//
//  Payment.swift
//  ExpenseTracker
//
//  Created by William Santoso on 27/02/22.
//

import Foundation

struct Payment: Codable {
    var id: UUID = UUID()
    let name: String
    var expenses: [Expense] = []
}
