//
//  RoolupProperty.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 30/12/21.
//

import Foundation

// MARK: - RoolupProperty
struct RoolupProperty<T: Codable>: Codable {
    var rollup: T
}
