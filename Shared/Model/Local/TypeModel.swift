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
    var type: String
    var keywords: String?
    var subcategoryOf: [String]? = nil
    var isMainCategory: Bool = true
    var nature: String?
}

struct Types: Codable {
    var allTypes: [TypeModel]
    var accountTypes: [TypeModel] {
        filterType(.account)
    }
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
        case account
        case income
        case expense
        case payment
        case duration
        case store
    }
    
    func filterType(_ category: TypeCategory) -> [TypeModel] {
        allTypes.filter { type in
            type.type == category.rawValue.capitalized
        }
    }
}
