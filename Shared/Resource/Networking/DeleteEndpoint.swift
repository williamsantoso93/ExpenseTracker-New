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
    func delete(id: String) throws -> AnyPublisher<Bool, Error> {
        let urlString = baseBlock + id
        
        do {
            let result = try deleteData(from: urlString)
            return Future<Bool, Error> { completion in
                result
                    .sink { result in
                        switch result {
                        case .finished:
                            completion(.success(true))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    } receiveValue: { data in
                        if data.response.isStatusOK() {
                            return completion(.success(true))
                        }
                        print(urlString)
                        print(String(data: data.data, encoding: .utf8) ?? "no data")
                        
                        if let errorResponseDecoded = try? JSONDecoder().decode(ErrorResponse.self, from: data.data) {
                            DispatchQueue.main.async {
                                GlobalData.shared.errorMessage = Mapper.errorMessageRemoteToLocal(errorResponseDecoded)
                            }
                            return completion(.failure(NetworkError.errorResponse(errorResponseDecoded)))
                        }
                    }
                    .store(in: &self.cancelables)
            }
            .eraseToAnyPublisher()
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
