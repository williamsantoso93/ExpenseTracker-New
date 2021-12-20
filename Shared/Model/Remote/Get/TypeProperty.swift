//
//  TypeProperty.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - TypeProperty
struct TypeProperty: Codable {
    let name: Title
    let category: SingleSelectProperty
    
    enum CodingKeys: String, CodingKey {
        case category = "Category"
        case name = "Name"
    }
}


