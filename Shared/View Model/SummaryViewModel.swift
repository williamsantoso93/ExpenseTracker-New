//
//  SummaryViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 23/12/21.
//

import Foundation

class SummaryViewModel: ObservableObject {
    @Published var isSelectUser = false
    
    init() {
        checkUser()
    }
    
    func checkUser() {
        if UserDefaults.standard.string(forKey: "user") != nil {
            isSelectUser = false
        } else {
            isSelectUser = true
        }
    }
}
