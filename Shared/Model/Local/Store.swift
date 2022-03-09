//
//  Store.swift
//  ExpenseTracker
//
//  Created by William Santoso on 27/02/22.
//

import Foundation

struct Store: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var isHaveMultipleStore: Bool
    var name: String
    var dateCreated: Date = Date()
    var dateUpdated: Date = Date()
}
