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
    case noPayment
    case noLabel
    case noAccount
    case noCategory
    case noCategoryNature
    case noSubcategory
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
                message: "Please select Type"
            )
        case .noDuration:
            return ErrorMessage(
                title: "Invalid Duration",
                message: "Please select Duration"
            )
        case .noPayment:
            return ErrorMessage(
                title: "Invalid Payment",
                message: "Please select Payment"
            )
        case .noLabel:
            return ErrorMessage(
                title: "Invalid Label",
                message: "Please select Label"
            )
        case .noAccount:
            return ErrorMessage(
                title: "Invalid Account",
                message: "Please select Account"
            )
        case .noCategory:
            return ErrorMessage(
                title: "Invalid Category",
                message: "Please select Category"
            )
        case .noCategoryNature:
            return ErrorMessage(
                title: "Invalid Category Nature",
                message: "Please select Category Nature"
            )
        case .noSubcategory:
            return ErrorMessage(
                title: "Invalid Subcateogry",
                message: "Please select Subcateogry"
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
    
    static func numberTextField(_ input: String) throws -> Double {
        let typeError: ValidationError = .noValue
        if input.isEmpty {
            throw typeError
        }
        guard let inputDouble = input.toDouble() else {
            throw typeError
        }
        if inputDouble < 0 {
            throw typeError
        }
        return inputDouble
    }
    
    static func picker(inputName: String, input: Any, typeError: ValidationError) throws -> Any {
        if inputName.isEmpty {
            throw typeError
        }
        return input
    }
    
    static func picker(_ input: Any?, typeError: ValidationError) throws -> Any {
        if let input = input {
            return input
        }
        throw typeError
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
