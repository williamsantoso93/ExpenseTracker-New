//
//  UpdateEndpoint.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

//MARK: - Update Data
extension Networking {
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
