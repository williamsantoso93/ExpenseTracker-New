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
    let type: SingleSelectProperty
    let subcategoryOf: MultiSelectProperty?
    var mainCategory: FormulaProperty? = nil
    var keywords: FormulaProperty? = nil
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case type = "Type"
        case subcategoryOf = "Subcategory of"
        case mainCategory = "Main Category"
        case keywords = "Keywords"
    }
}


