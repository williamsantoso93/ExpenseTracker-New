//
//  Store.swift
//  ExpenseTracker
//
//  Created by William Santoso on 27/02/22.
//

import Foundation

struct Store: Codable {
    var id: UUID = UUID()
    let isHaveMultipleStore: Bool
    let name: String
}
