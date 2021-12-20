//
//  TypePostProperty.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - TypePostProperty
struct TypePostProperty: Codable {
    let name: TitleProperty
    let category: SingleSelectProperty
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case category = "Category"
    }
}
