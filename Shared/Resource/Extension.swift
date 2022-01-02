//
//  Extension.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation


extension String {
    func splitDigit() -> String {
        if !self.isEmpty {
            if let number = Int(self.replacingOccurrences(of: ".", with: "")) {
                return number.splitDigit()
            }
            return self
        }
        return self
    }
    
    func toInt() -> Int {
        Int(self.replacingOccurrences(of: ".", with: "")) ?? 0
    }
}

extension Int {
    func splitDigit() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = "."
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension String {
    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func toYearMonthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM MMMM"
        
        // US English Locale (en_US)
        dateFormatter.locale = Locale(identifier: "en_US")
        
        return dateFormatter.string(from: self)
    }
    
    func addMonth(by n: Int = 1) -> Date? {
        var dateComponent = DateComponents()
        dateComponent.month = n
        
        return Calendar.current.date(byAdding: dateComponent, to: self)
    }
}

extension Array where Element == String {
    func joinedWithComma() -> String {
        self.joined(separator: ", ")
    }
}

extension URLResponse {
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
    
    func isStatusOK() -> Bool {
        if let statusCode = self.getStatusCode() {
            if statusCode >= 200 && statusCode < 300 {
                return true
            }
        }
        return false
    }
}
