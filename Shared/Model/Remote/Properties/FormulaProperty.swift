//
//  FormulaProperty.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 03/01/22.
//

import Foundation

// MARK: - FormulaProperty
struct FormulaProperty: Codable {
    var formula: FormulaString
}

// MARK: - FormulaString
struct FormulaString: Codable {
    var string: String
}
