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
    let properties: T
    
    enum CodingKeys: String, CodingKey {
        case properties
    }
}

// MARK: - Sort
struct Sort: Codable {
    let property, direction: String?
}

// MARK: - ErrorResponse
struct ErrorResponse: Codable {
    let status: Int
    let code, message: String
}
