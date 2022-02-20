//
//  DeleteEndpoint.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation
import Combine

//MARK: - Delete Data
extension Networking {
    func delete(id: String) throws -> AnyPublisher<DefaultResponse<Bool>, Error> {
        let urlString = baseBlock + id
        
        do {
            let result = try deleteData(from: urlString, responseType: DefaultResponse<Bool>.self)
                .eraseToAnyPublisher()
            return result
        } catch {
            throw error
        }
    }
    
    func delete(id: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = baseBlock + id
        
        deleteData(from: urlString) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in            
            self.defaultResultIsSuccess(result, isSuccess) { isSuccess in
                return completion(isSuccess)
            }
        }
    }
}
