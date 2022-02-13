//
//  TypeModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - Type
struct TypeModel: Codable {
    var blockID: String
    var name: String
    var category: String
    var keywords: String?
    var subcategoryOf: [String]? = nil
    var isMainCategory: Bool = true
}

struct Types: Codable {
    var allTypes: [TypeModel]
    var incomeTypes: [TypeModel] {
        filterType(.income)
    }
    var expenseTypes: [TypeModel] {
        filterType(.expense)
    }
    var paymentTypes: [TypeModel] {
        filterType(.payment)
    }
    var durationTypes: [TypeModel] {
        filterType(.duration)
    }
    var storeTypes: [TypeModel] {
        filterType(.store)
    }
    
    init(allTypes: [TypeModel] = []) {
        self.allTypes = allTypes
    }
    
    enum TypeCategory: String, CaseIterable {
        case income
        case expense
        case payment
        case duration
        case store
    }
    
    func filterType(_ category: TypeCategory) -> [TypeModel] {
        allTypes.filter { type in
            type.category == category.rawValue.capitalized
        }
    }
}
