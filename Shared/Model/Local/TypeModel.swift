//
//  TypeModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - Type
struct TypeModel: Codable {
    var id: String = UUID().uuidString
    var notionID: String?
    var name: String
    var category: String
    var keywords: String?
}

enum TypeCategory: String, CaseIterable, Codable {
    case duration
    case expense
    case income
    case payment
    case store
    
    func getTypeCategory(_ string: String) -> TypeCategory {
        TypeCategory(rawValue: string) ?? .expense
    }
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
    
    func filterType(_ category: TypeCategory) -> [TypeModel] {
        allTypes.filter { type in
            type.category == category.rawValue.capitalized
        }
    }
}
