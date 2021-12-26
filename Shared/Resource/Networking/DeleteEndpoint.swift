//
//  DeleteEndpoint.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

//MARK: - Delete Data
extension Networking {
    func delete(id: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = baseBlock + id
        
        deleteData(from: urlString) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
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
