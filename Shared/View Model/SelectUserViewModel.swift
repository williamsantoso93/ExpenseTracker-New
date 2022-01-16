//
//  SelectUserViewModel.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 15/01/22.
//

import Foundation

enum User: String {
    case william
    case paramitha
}

class SelectUserViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var user = User.william
    let defaults = UserDefaults.standard

    func setUser(_ user: User) {
        isLoading = true
        
        defaults.set(user.rawValue, forKey: "user")
        
        isLoading = false
    }
}
