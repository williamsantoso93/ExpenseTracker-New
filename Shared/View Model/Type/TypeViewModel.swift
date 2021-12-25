//
//  TypeViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

class TypeViewModel: ObservableObject {
    func filterType(_ category: Types.TypeCategory) -> [TypeModel] {
        GlobalData.shared.types.allTypes.filter { type in
            type.category == category.rawValue.capitalized
        }
    }
}
