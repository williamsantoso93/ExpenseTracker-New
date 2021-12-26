//
//  UpdateEndpoint.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

//MARK: - Update Data
extension Networking {
    func updateExpense(id: String, expense: Expense, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage + id
        
        let update = DefaultUpdate(
            properties: Mapper.expenseLocalToRemote(expense)
        )
        
        patchData(to: urlString, patchData: update) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
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
    
    func updateIncome(id: String, income: Income, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage + id
        
        let update = DefaultUpdate(
            properties: Mapper.incomeLocalToRemote(income)
        )
        
        patchData(to: urlString, patchData: update) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
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
    
    func updateType(id: String, typeModel: TypeModel, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage + id
        
        let update = DefaultUpdate(
            properties: Mapper.typeLocalToRemote(typeModel)
        )
        
        patchData(to: urlString, patchData: update) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
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
