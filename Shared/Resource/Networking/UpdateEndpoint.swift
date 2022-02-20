//
//  UpdateEndpoint.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation
import Combine

//MARK: - Update Data
extension Networking {
    func updateExpense(_ expense: Expense) throws -> AnyPublisher<DefaultResponse<Bool>, Error> {
        let urlString = basePage + expense.blockID
        
        let update = DefaultUpdate(
            properties: Mapper.expenseLocalToRemote(expense)
        )
        
        do {
            let result = try patchData(to: urlString, patchData: update, responseType: DefaultResponse<Bool>.self)
                .eraseToAnyPublisher()
            return result
        } catch {
            throw error
        }
    }
    
    func updateExpense(_ expense: Expense, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage + expense.blockID
        
        let update = DefaultUpdate(
            properties: Mapper.expenseLocalToRemote(expense)
        )
        
        patchData(to: urlString, patchData: update) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            self.defaultResultIsSuccess(result, isSuccess) { isSuccess in
                return completion(isSuccess)
            }
        }
    }
    
    func updateIncome(_ income: Income) throws -> AnyPublisher<DefaultResponse<Bool>, Error> {
        let urlString = basePage + income.blockID
        
        let update = DefaultUpdate(
            properties: Mapper.incomeLocalToRemote(income)
        )
        
        do {
            let result = try patchData(to: urlString, patchData: update, responseType: DefaultResponse<Bool>.self)
                .eraseToAnyPublisher()
            return result
        } catch {
            throw error
        }
    }
    
    func updateIncome(_ income: Income, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage + income.blockID
        
        let update = DefaultUpdate(
            properties: Mapper.incomeLocalToRemote(income)
        )
        
        patchData(to: urlString, patchData: update) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            self.defaultResultIsSuccess(result, isSuccess) { isSuccess in
                return completion(isSuccess)
            }
        }
    }
    
    func updateType(_ typeModel: TypeModel) throws -> AnyPublisher<DefaultResponse<Bool>, Error> {
        let urlString = basePage + typeModel.blockID
        
        let update = DefaultUpdate(
            properties: Mapper.typeLocalToRemote(typeModel)
        )
        
        do {
            let result = try patchData(to: urlString, patchData: update, responseType: DefaultResponse<Bool>.self)
                .eraseToAnyPublisher()
            return result
        } catch {
            throw error
        }
    }
    
    func updateType(_ typeModel: TypeModel, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage + typeModel.blockID
        
        let update = DefaultUpdate(
            properties: Mapper.typeLocalToRemote(typeModel)
        )
        
        patchData(to: urlString, patchData: update) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            self.defaultResultIsSuccess(result, isSuccess) { isSuccess in
                return completion(isSuccess)
            }
        }
    }
    
    func updateTemplateModel(_ templateModel: TemplateModel) throws -> AnyPublisher<DefaultResponse<Bool>, Error> {
        let urlString = basePage + templateModel.blockID
        
        let update = DefaultUpdate(
            properties: Mapper.templateModelLocalToRemote(templateModel)
        )
        
        do {
            let result = try patchData(to: urlString, patchData: update, responseType: DefaultResponse<Bool>.self)
                .eraseToAnyPublisher()
            return result
        } catch {
            throw error
        }
    }
    
    func updateTemplateModel(_ templateModel: TemplateModel, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage + templateModel.blockID
        
        let update = DefaultUpdate(
            properties: Mapper.templateModelLocalToRemote(templateModel)
        )
        
        patchData(to: urlString, patchData: update) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            self.defaultResultIsSuccess(result, isSuccess) { isSuccess in
                return completion(isSuccess)
            }
        }
    }
}
