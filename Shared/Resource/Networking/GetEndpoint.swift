//
//  GetEndpoint.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

//MARK: - Get Data
extension Networking {
    func defaultReturnData<T: Codable>(_ result: Result<DefaultResponse<T>, NetworkError>, completion: @escaping (Result<DefaultResponse<T>, NetworkError>) -> Void) {
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                return completion(.success(data))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
    
    func getIncome(startCursor: String? = nil, completion: @escaping (Result<DefaultResponse<IncomeProperty>, NetworkError>) -> Void) {
        let urlString = baseDatabase + DatabaseID.incomeDatabaseID.rawValue + "/query"
        
        let post = Query(
            startCursor: startCursor,
            sorts: [
                Sort(property: "Date", direction: SortDirection.descending.rawValue)
            ]
        )
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<IncomeProperty>, NetworkError>, response, dataResponse, isSuccess) in
            self.defaultReturnData(result) { result in
                return completion(result)
            }
        }
    }
    
    func getExpense(startCursor: String? = nil, completion: @escaping (Result<DefaultResponse<ExpenseProperty>, NetworkError>) -> Void) {
        let urlString = baseDatabase + DatabaseID.expenseDatabaseID.rawValue + "/query"
        
        let post = Query(
            startCursor: startCursor,
            sorts: [
                Sort(property: "Date", direction: SortDirection.descending.rawValue)
            ]
        )
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<ExpenseProperty>, NetworkError>, response, dataResponse, isSuccess) in
            self.defaultReturnData(result) { result in
                return completion(result)
            }
        }
    }
    
    func getYearMonth(startCursor: String? = nil, completion: @escaping (Result<DefaultResponse<YearMonthProperty>, NetworkError>) -> Void) {
        let urlString = baseDatabase + DatabaseID.yearMonthDatabaseID.rawValue + "/query"
        
        let post = Query(
            startCursor: startCursor,
            sorts: [
                Sort(property: "Name", direction: SortDirection.ascending.rawValue)
            ]
        )
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<YearMonthProperty>, NetworkError>, response, dataResponse, isSuccess) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    return completion(.success(data))
                case .failure(let error):
                    return completion(.failure(error))
                }
            }
        }
    }
    
    func getTypes(startCursor: String? = nil, completion: @escaping (Result<DefaultResponse<TypeProperty>, NetworkError>) -> Void) {
        let urlString = baseDatabase + DatabaseID.typeDatabaseID.rawValue + "/query"
        
        let post = Query(
            startCursor: startCursor,
            sorts: [
                Sort(property: "Name", direction: SortDirection.ascending.rawValue)
            ]
        )
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<TypeProperty>, NetworkError>, response, dataResponse, isSuccess) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    return completion(.success(data))
                case .failure(let error):
                    return completion(.failure(error))
                }
            }
        }
    }
    
    func getTemplateModel(startCursor: String? = nil, completion: @escaping (Result<DefaultResponse<TemplateModelProperty>, NetworkError>) -> Void) {
        let urlString = baseDatabase + DatabaseID.templateModelDatabaseID.rawValue + "/query"
        
        let post = Query(
            startCursor: startCursor,
            sorts: [
                Sort(property: "Name", direction: SortDirection.ascending.rawValue)
            ]
        )
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<TemplateModelProperty>, NetworkError>, response, dataResponse, isSuccess) in
            self.defaultReturnData(result) { result in
                return completion(result)
            }
        }
    }
}
