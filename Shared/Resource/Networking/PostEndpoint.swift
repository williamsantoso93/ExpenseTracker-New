//
//  PostEndpoint.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

//MARK: - Post Data
extension Networking {
    func defaultResultIsSuccess(_ result: Result<DefaultResponse<Bool>, NetworkError>, _ isSuccess: Bool, completion: @escaping (_ isSuccess: Bool) -> Void) {
        DispatchQueue.main.async {
            switch result {
            case .success(_):
                return completion(isSuccess)
            case .failure(let failure):
                if isSuccess {
                    return completion(isSuccess)
                } else {
                    print(failure)
                    return completion(false)
                }
            }
        }
    }
    
    func postExpense(_ expense: Expense, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: getDatabaseID(.expenseDatabaseID)),
            properties: Mapper.expenseLocalToRemote(expense)
        )
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            self.defaultResultIsSuccess(result, isSuccess) { isSuccess in
                return completion(isSuccess)
            }
        }
    }
    
    func postIncome(_ income: Income, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: getDatabaseID(.incomeDatabaseID)),
            properties: Mapper.incomeLocalToRemote(income)
        )
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            self.defaultResultIsSuccess(result, isSuccess) { isSuccess in
                return completion(isSuccess)
            }
        }
    }
    
    func postYearMonth(_ yearMonth: YearMonth, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: getDatabaseID(.yearMonthDatabaseID)),
            properties: Mapper.yearMonthLocalToRemote(yearMonth)
        )
        
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            self.defaultResultIsSuccess(result, isSuccess) { isSuccess in
                return completion(isSuccess)
            }
        }
    }
    
    func postType(_ typeModel: TypeModel, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: getDatabaseID(.typeDatabaseID)),
            properties: Mapper.typeLocalToRemote(typeModel)
        )
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            self.defaultResultIsSuccess(result, isSuccess) { isSuccess in
                return completion(isSuccess)
            }
        }
    }
    
    func postTemplateModel(_ templateModel: TemplateModel, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: getDatabaseID(.templateModelDatabaseID)),
            properties: Mapper.templateModelLocalToRemote(templateModel)
        )
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            self.defaultResultIsSuccess(result, isSuccess) { isSuccess in
                return completion(isSuccess)
            }
        }
    }
}
