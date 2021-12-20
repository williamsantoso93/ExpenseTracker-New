//
//  Extension.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

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
