//
//  Validation.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 27/12/21.
//

import Foundation

enum ValidationError: Error {
    case noName
    case noValue
    case noType
    case noDuration
    case noPaymentVia
    case noCategory
}

extension ValidationError {
    public var errorMessage: ErrorMessage? {
        switch self {
        case .noName:
            return ErrorMessage(
                title: "Invalid Name",
                message: "Please input name"
            )
        case .noValue:
            return ErrorMessage(
                title: "Invalid Value",
                message: "Please input value"
            )
        case .noType:
            return ErrorMessage(
                title: "Invalid Type",
                message: "Please select type"
            )
        case .noDuration:
            return ErrorMessage(
                title: "Invalid Duration",
                message: "Please select duration"
            )
        case .noPaymentVia:
            return ErrorMessage(
                title: "Invalid Payment",
                message: "Please select payment"
            )
        case .noCategory:
            return ErrorMessage(
                title: "Invalid Category",
                message: "Please select category"
            )
        }
    }
}

class Validation {
    static func textField(_ input: String, typeError: ValidationError = .noName) throws -> String {
        if input.isEmpty {
            throw typeError
        }
        return input
    }
    
    static func textField(_ input: String, typeError: ValidationError = .noName, handler: Void) -> String {
        if input.isEmpty {
            GlobalData.shared.errorMessage = typeError.errorMessage
            handler
        }
        return input
    }
    
    static func numberTextField(_ input: Int) throws -> Int {
        if input <= 0 {
            throw ValidationError.noValue
        }
        return input
    }
    static func numberTextField(_ input: Int, handler: @escaping (Int) -> Void) {
        if input <= 0 {
            GlobalData.shared.errorMessage = ValidationError.noValue.errorMessage
        }
        return handler(input)
    }
    
    static func picker(_ input: String, typeError: ValidationError) throws -> String {
        if input.isEmpty {
            throw typeError
        }
        return input
    }
    static func picker(_ input: String, typeError: ValidationError, handler: @escaping (String) -> Void) {
        if input.isEmpty {
            GlobalData.shared.errorMessage = typeError.errorMessage
        }
        return handler(input)
    }
}
