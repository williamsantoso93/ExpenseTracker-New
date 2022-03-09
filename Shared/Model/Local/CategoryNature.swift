//
//  CategoryNature.swift
//  ExpenseTracker
//
//  Created by William Santoso on 27/02/22.
//

import Foundation

struct CategoryNature: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var dateCreated: Date = Date()
    var dateUpdated: Date = Date()
    var categories: [Category] = []
}
