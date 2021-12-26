//
//  PostEndpoint.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

//MARK: - Post Data
extension Networking {
    func postExpense(_ expense: Expense, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: DatabaseID.expenseDatabaseID.rawValue),
            properties: Mapper.expenseLocalToRemote(expense)
        )
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    print(success)
                    return completion(isSuccess)
                case .failure(let failure):
                    if isSuccess {
                        return completion(isSuccess)
                    } else {
                        print(failure)
                    }
                }
            }
        }
    }
    
    func postIncome(_ income: Income, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: DatabaseID.incomeDatabaseID.rawValue),
            properties: Mapper.incomeLocalToRemote(income)
        )
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    print(success)
                    return completion(isSuccess)
                case .failure(let failure):
                    if isSuccess {
                        return completion(isSuccess)
                    } else {
                        print(failure)
                    }
                }
            }
        }
    }
    
    func postYearMonth(_ yearMonth: YearMonth, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: DatabaseID.yearMonthDatabaseID.rawValue),
            properties: Mapper.yearMonthLocalToRemote(yearMonth)
        )
        
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    print(success)
                    return completion(isSuccess)
                case .failure(let failure):
                    if isSuccess {
                        return completion(isSuccess)
                    } else {
                        print(failure)
                    }
                }
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
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    print(success)
                    return completion(isSuccess)
                case .failure(let failure):
                    if isSuccess {
                        return completion(isSuccess)
                    } else {
                        print(failure)
                    }
                }
            }
        }
    }
}
