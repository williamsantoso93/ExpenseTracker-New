//
//  FormulaProperty.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 03/01/22.
//

import Foundation

// MARK: - FormulaProperty
struct FormulaProperty: Codable {
    var formula: Formula
}

// MARK: - FormulaString
struct Formula: Codable {
    var string: String?
    var boolean: Bool?
}
