//
//  DefaultPost.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - DefaultPost
struct DefaultPost<T: Codable>: Codable {
    let parent: Parent
    let properties: T
}

// MARK: - Parent
struct Parent: Codable {
    let databaseID: String
    
    enum CodingKeys: String, CodingKey {
        case databaseID = "database_id"
    }
}

