//
//  RelationProperty.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - RelationProperty
struct RelationProperty: Codable {
    let relation: [Relation]
}

// MARK: - Relation
struct Relation: Codable {
    let id: String
}
