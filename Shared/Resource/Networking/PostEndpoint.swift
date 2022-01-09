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
    
    func postExpense(_ expense: ExpenseModel, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: DatabaseID.expenseDatabaseID.rawValue),
            properties: Mapper.expenseLocalToRemote(expense)
        )
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            self.defaultResultIsSuccess(result, isSuccess) { isSuccess in
                return completion(isSuccess)
            }
        }
    }
    
    func postIncome(_ income: IncomeModel, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: DatabaseID.incomeDatabaseID.rawValue),
            properties: Mapper.incomeLocalToRemote(income)
        )
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            self.defaultResultIsSuccess(result, isSuccess) { isSuccess in
                return completion(isSuccess)
            }
        }
    }
    
    func postYearMonth(_ yearMonth: YearMonthModel, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: DatabaseID.yearMonthDatabaseID.rawValue),
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
            parent: Parent(databaseID: DatabaseID.typeDatabaseID.rawValue),
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
            parent: Parent(databaseID: DatabaseID.templateModelDatabaseID.rawValue),
            properties: Mapper.templateModelLocalToRemote(templateModel)
        )
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            self.defaultResultIsSuccess(result, isSuccess) { isSuccess in
                return completion(isSuccess)
            }
        }
    }
}
