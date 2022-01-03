//
//  TypeProperty.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - TypeProperty
struct TypeProperty: Codable {
    let name: TitleProperty
    let category: SingleSelectProperty
    var keywords: FormulaProperty? = nil
    
    enum CodingKeys: String, CodingKey {
        case category = "Category"
        case name = "Name"
        case keywords = "Keywords"
    }
}


