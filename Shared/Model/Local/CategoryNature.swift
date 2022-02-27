//
//  CategoryNature.swift
//  ExpenseTracker
//
//  Created by William Santoso on 27/02/22.
//

import Foundation

struct CategoryNature: Codable {
    var id: UUID = UUID()
    let name: String
    var categories: [Category] = []
}
