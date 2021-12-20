//
//  TextProperty.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - Text
struct TextContent: Codable {
    let content: String
}

// MARK: - TitleProperty
struct TitleProperty: Codable {
    let title: [Title]
}

// MARK: - Title
struct Title: Codable {
    let text: TextContent
    
    enum CodingKeys: String, CodingKey {
        case text
    }
}

// MARK: - RichTextProperty
struct RichTextProperty: Codable {
    let richText: [RichText]
    
    enum CodingKeys: String, CodingKey {
        case richText = "rich_text"
    }
}

// MARK: - RichText
struct RichText: Codable {
    let type: String?
    let text: TextContent
    
    enum CodingKeys: String, CodingKey {
        case type
        case text
    }
}
