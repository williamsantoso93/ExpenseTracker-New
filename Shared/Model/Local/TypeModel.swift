//
//  TypeModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

// MARK: - Type
struct TypeModel: Codable {
    let name: String
    let category: String
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
    
    init(allTypes: [TypeModel] = []) {
        self.allTypes = allTypes
    }
    
    enum TypeCategory: String {
        case income
        case expense
        case payment
        case duration
    }
    
    func filterType(_ category: TypeCategory) -> [TypeModel] {
        allTypes.filter { type in
            type.category == category.rawValue.capitalized
        }
    }
}
