//
//  PostEndpoint.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation
import Combine

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
    
    func defaultResultIsSuccess(_ completion: Subscribers.Completion<Error>, futureCompletion: ((Result<Bool, Error>) -> Void)) {
        if case let .failure(error) = completion {
            switch error {
            case let decodingError as DecodingError:
                futureCompletion(.failure(decodingError))
            case let apiError as NetworkError:
                switch apiError {
                case .isStatusOK(let isStatusOK):
                    futureCompletion(.success(isStatusOK))
                default:
                    futureCompletion(.failure(apiError))
                }
            default:
                futureCompletion(.failure(NetworkError.unknown))
            }
        }
    }
    
    func postExpense(_ expense: Expense) -> Future<Bool, Error> {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: getDatabaseID(.expenseDatabaseID)),
            properties: Mapper.expenseLocalToRemote(expense)
        )
        
        return Future<Bool, Error> { futureCompletion in
            self.postData(to: urlString, postData: post, responseType: DefaultResponse<Bool>.self)
                .sink(receiveCompletion: { completion in
                    self.defaultResultIsSuccess(completion) { result in
                        futureCompletion(result)
                    }
                }, receiveValue: { data in
                    futureCompletion(.success(true))
                })
                .store(in: &self.cancellables)
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
    
    func postIncome(_ income: Income) -> Future<Bool, Error> {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: getDatabaseID(.incomeDatabaseID)),
            properties: Mapper.incomeLocalToRemote(income)
        )
        
        return Future<Bool, Error> { futureCompletion in
            self.postData(to: urlString, postData: post, responseType: DefaultResponse<Bool>.self)
                .sink(receiveCompletion: { completion in
                    self.defaultResultIsSuccess(completion) { result in
                        futureCompletion(result)
                    }
                }, receiveValue: { data in
                    futureCompletion(.success(true))
                })
                .store(in: &self.cancellables)
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
    
    func postYearMonth(_ yearMonth: YearMonth) -> Future<Bool, Error> {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: getDatabaseID(.yearMonthDatabaseID)),
            properties: Mapper.yearMonthLocalToRemote(yearMonth)
        )
        
        return Future<Bool, Error> { futureCompletion in
            self.postData(to: urlString, postData: post, responseType: DefaultResponse<Bool>.self)
                .sink(receiveCompletion: { completion in
                    self.defaultResultIsSuccess(completion) { result in
                        futureCompletion(result)
                    }
                }, receiveValue: { data in
                    futureCompletion(.success(true))
                })
                .store(in: &self.cancellables)
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
    
    func postType(_ typeModel: TypeModel) -> Future<Bool, Error> {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: getDatabaseID(.typeDatabaseID)),
            properties: Mapper.typeLocalToRemote(typeModel)
        )
        
        return Future<Bool, Error> { futureCompletion in
            self.postData(to: urlString, postData: post, responseType: DefaultResponse<Bool>.self)
                .sink(receiveCompletion: { completion in
                    self.defaultResultIsSuccess(completion) { result in
                        futureCompletion(result)
                    }
                }, receiveValue: { data in
                    futureCompletion(.success(true))
                })
                .store(in: &self.cancellables)
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
    
    func postTemplateModel(_ templateModel: TemplateModel) -> Future<Bool, Error> {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: getDatabaseID(.templateModelDatabaseID)),
            properties: Mapper.templateModelLocalToRemote(templateModel)
        )
        
        return Future<Bool, Error> { futureCompletion in
            self.postData(to: urlString, postData: post, responseType: DefaultResponse<Bool>.self)
                .sink(receiveCompletion: { completion in
                    self.defaultResultIsSuccess(completion) { result in
                        futureCompletion(result)
                    }
                }, receiveValue: { data in
                    futureCompletion(.success(true))
                })
                .store(in: &self.cancellables)
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
