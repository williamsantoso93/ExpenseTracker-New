//
//  Util.swift
//  ExpenseTracker
//
//  Created by William Santoso on 22/04/23.
//

import Foundation

class Util {
    static func setUserDefaultValue(key: UserDefaultKey, value: String) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    static func getUserDefaultValue(key: UserDefaultKey) -> String {
        return UserDefaults.standard.string(forKey: key.rawValue) ?? ""
    }
    
    static func removeUserDefaultString(keys: [UserDefaultKey] = [.expenseDate, .incomeDate, .label, .account]) {
        for key in keys {
            Util.setUserDefaultValue(key: key, value: "")
        }
    }
    
    static func stringToDate(date: String, format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: date) ?? Date()
    }
    
    static func dateToString(date: Date, format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}

enum UserDefaultKey: String {
    case expenseDate
    case incomeDate
    case label
    case account
}
