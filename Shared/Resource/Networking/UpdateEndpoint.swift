//
//  UpdateEndpoint.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

//MARK: - Update Data
extension Networking {
    func updateExpense(_ expense: ExpenseModel, completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let id = expense.notionID else { return }
        let urlString = basePage + id
        
        let update = DefaultUpdate(
            properties: Mapper.expenseLocalToRemote(expense)
        )
        
        patchData(to: urlString, patchData: update) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            self.defaultResultIsSuccess(result, isSuccess) { isSuccess in
                return completion(isSuccess)
            }
        }
    }
    
    func updateIncome(_ income: IncomeModel, completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let id = income.notionID else { return }
        let urlString = basePage + id
        
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
        guard let id = typeModel.notionID else { return }
        let urlString = basePage + id
        
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
        guard let id = templateModel.notionID else { return }
        let urlString = basePage + id
        
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
