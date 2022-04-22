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
    
    func splitDigitDouble() -> String {
        if let decimalSeparator = Locale.current.decimalSeparator {
            guard let last = self.last else { return self }
            let lastString: String = "\(String(describing: last))"
            if lastString != decimalSeparator && (!self.contains(decimalSeparator)) {
                return self.toDouble()?.splitDigit(maximumFractionDigits: 0) ?? self
            } else {
                let decimalSeparatorCounter = self.components(separatedBy: decimalSeparator).count - 1
                if lastString == decimalSeparator && decimalSeparatorCounter > 1 {
                    return String(self.dropLast())
                }
            }
        }
        
        return self
    }
    
    func toInt() -> Int {
        if let groupingSeparator = Locale.current.groupingSeparator {
            return Int(self.replacingOccurrences(of: groupingSeparator, with: "")) ?? 0
        }
        
        return 0
    }
    
    func toDouble() -> Double? {
        if !self.isEmpty {
            if let groupingSeparator = Locale.current.groupingSeparator {
                var valueString = self.replacingOccurrences(of: groupingSeparator, with: "")
                if valueString.contains(",") {
                    valueString = valueString.replacingOccurrences(of: ",", with: ".")
                }
                return Double(valueString)
            }
        }
        
        return nil
    }
    
    func trimWhitespace() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension Double {
    func splitDigit(with groupingSeparator: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.groupingSeparator = groupingSeparator
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    func splitDigit() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    func splitDigit(maximumFractionDigits: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if maximumFractionDigits > 0 {
            numberFormatter.maximumFractionDigits = maximumFractionDigits
        }
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
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
