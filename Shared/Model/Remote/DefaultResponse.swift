//
//  DefaultResponse.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - DefaultResponse
struct DefaultResponse<T : Codable>: Codable {
    let results: [ResultProperty<T>]
    let nextCursor: String?
    let hasMore: Bool
    
    enum CodingKeys: String, CodingKey {
        case results
        case nextCursor = "next_cursor"
        case hasMore = "has_more"
    }
}

// MARK: - Result
struct ResultProperty<T : Codable>: Codable {
    let id: String
    let properties: T
    
    enum CodingKeys: String, CodingKey {
        case id
        case properties
    }
}

// MARK: - Query
struct Query: Codable {
    var startCursor: String? = nil
    var pageSize: Int? = nil
    var sorts: [Sort]? = nil
    
    enum CodingKeys: String, CodingKey {
        case startCursor = "start_cursor"
        case pageSize = "page_size"
        case sorts
    }
}

// MARK: - Sort
struct Sort: Codable {
    var property: String?
    var timestamp: String? = nil
    var direction: String?
}

// MARK: - ErrorResponse
struct ErrorResponse: Codable {
    let status: Int
    let code, message: String
}

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

// MARK: - DefaultUpdate
struct DefaultUpdate<T: Codable>: Codable {
    let properties: T
}
