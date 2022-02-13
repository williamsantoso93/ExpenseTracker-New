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
                message: "Please select category"
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
    
    static func numberTextField(_ input: Double) throws -> Double {
        if input <= 0 {
            throw ValidationError.noValue
        }
        return input
    }
    
    static func picker(_ input: String, typeError: ValidationError) throws -> String {
        if input.isEmpty {
            throw typeError
        }
        return input
    }
    
    static func picker(_ inputs: [String], typeError: ValidationError) throws -> [String] {
        if inputs.isEmpty {
            throw typeError
        }
        return inputs
    }
}
