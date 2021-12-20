//
//  Extension.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

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
