//
//  DefaultResponse.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - DefaultResponse
struct DefaultResponse<T : Codable>: Codable {
    let object: String
    let results: [Result<T>]
    let nextCursor: String?
    let hasMore: Bool
    
    enum CodingKeys: String, CodingKey {
        case object, results
        case nextCursor = "next_cursor"
        case hasMore = "has_more"
    }
}

// MARK: - Result
struct Result<T : Codable>: Codable {
    let properties: T
    
    enum CodingKeys: String, CodingKey {
        case properties
    }
}
