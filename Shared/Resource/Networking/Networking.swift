//
//  Networking.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation
import Combine

enum NetworkError: Error {
    case badUrl
    case responseError
    case decodingError(String)
    case encodingError
    case noData
    case notLogin
    case errorMessage(String)
    case statusCode(Int?)
    case errorResponse(ErrorResponse)
    case dataNotComplete
    case isStatusOK(Bool)
    case unknown
}

class Networking {
    let base = "https://api.notion.com/v1/"
    var baseDatabase: String {
        return base + "databases/"
    }
    var basePage: String {
        return base + "pages/"
    }
    var baseBlock: String {
        return base + "blocks/"
    }
    var user: User? {
        if let user = UserDefaults.standard.string(forKey: "user") {
            return User(rawValue: user)
        }
        
        return nil
    }
    var bearerToken: String {
        guard let user = user else { return "" }
        switch user {
        case .william:
            return "secret_yUINPEksksZKF6AMsyzhCKX03fSmKeD1FVblA41DoCu"
        case .paramitha:
            return "secret_8BwqfsjdiHtbN2v5Hq2fl7Z1Ka9ySPXvtdnKu6ZcJUS"
        }
    }
    let notionVersion = "2021-08-16"
    
    enum DatabaseID: String {
        case expenseDatabaseID = "695f266fc30d49fd8f430d17661c90a0"
        case incomeDatabaseID = "e5e0a95e277748b69def274e17e4f693"
        case yearMonthDatabaseID = "741f8897815542cba0f20110fe0c2adc"
        case typeDatabaseID = "030a40c2dfed4ed08d42950d25af4466"
        case templateModelDatabaseID = "ddf9d34742994bc1a568d8aff356f737"
    }
    
    func getDatabaseID(_ databaseID: DatabaseID) -> String {
        if let user = user {
            if user == .paramitha {
                switch databaseID {
                case .expenseDatabaseID:
                    return "d35b5f3a75b44e448b02d49e8c87032d"
                case .incomeDatabaseID:
                    return "8b2fb7c23d9640c4b6a8e24befb9358d"
                case .yearMonthDatabaseID:
                    return "4c3450b81ca04dca8f4ff05bc81dd3b5"
                case .typeDatabaseID:
                    return "6bd8ced9ad40429ab616608522ecb78d"
                case .templateModelDatabaseID:
                    return "8a0146c2fc15406887fe789e44f12ddf"
                }
            }
            return databaseID.rawValue
        }
        return databaseID.rawValue
    }
    
    enum SortDirection: String {
        case ascending = "ascending"
        case descending = "descending"
    }
    enum SortTimestamp: String {
        case createdTime = "created_time"
        case lastEditedTime = "last_edited_time"
    }
    
    private init() { }
    
    static let shared = Networking()
    
    var cancellables = Set<AnyCancellable>()
    
    func getData<T: Decodable>(from urlString: String, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { futureCompletion in
            guard let url = URL(string: urlString) else {
                return futureCompletion(.failure(NetworkError.badUrl))
            }
            
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(self.bearerToken)", forHTTPHeaderField: "Authorization")
            request.setValue("\(self.notionVersion)", forHTTPHeaderField: "Notion-Version")
            
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    if let errorResponseDecoded = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        DispatchQueue.main.async {
                            GlobalData.shared.errorMessage = Mapper.errorMessageRemoteToLocal(errorResponseDecoded)
                        }
                        throw NetworkError.errorResponse(errorResponseDecoded)
                    }
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            futureCompletion(.failure(decodingError))
                        case let apiError as NetworkError:
                            futureCompletion(.failure(apiError))
                        default:
                            futureCompletion(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: { futureCompletion(.success($0)) })
                .store(in: &self.cancellables)
        }
    }
    
    func getData<T:Codable>(from urlString: String, completion: @escaping ((Result<T,NetworkError>), URLResponse?, Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            return completion(.failure(.badUrl), nil, nil)
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("\(notionVersion)", forHTTPHeaderField: "Notion-Version")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(urlString)
                return completion(.failure(.noData), response, nil)
            }
            
            guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
                print(urlString)
                print(String(data: data, encoding: .utf8) ?? "no data")
                
                if let errorResponseDecoded = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    DispatchQueue.main.async {
                        GlobalData.shared.errorMessage = Mapper.errorMessageRemoteToLocal(errorResponseDecoded)
                    }
                    return completion(.failure(.errorResponse(errorResponseDecoded)), response, data)
                }
                
                return completion(.failure(.errorMessage(data.jsonToString())), response, data)
            }
            completion(.success(decoded), response, data)
        }.resume()
    }
    
    func postDataNoResponse<T:Codable>(to urlString: String, postData: T?) -> Future<Bool, Error> {
        return Future<Bool, Error> { futureCompletion in
            guard let url = URL(string: urlString) else {
                return futureCompletion(.failure(NetworkError.badUrl))
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(self.bearerToken)", forHTTPHeaderField: "Authorization")
            request.setValue("\(self.notionVersion)", forHTTPHeaderField: "Notion-Version")
            
            
            if let postData = postData {
                guard let jsonData = try? JSONEncoder().encode(postData) else {
                    print(postData)
                    print("Error: Trying to convert model to JSON data")
                    return futureCompletion(.failure(NetworkError.encodingError))
                }
                
                request.httpBody = jsonData
            }
            
            URLSession.shared.dataTaskPublisher(for: request)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        futureCompletion(.failure(error))
                    }
                }, receiveValue: { output in
                    let data = output.data
                    let response = output.response
                    
                    if let errorResponseDecoded = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        print(urlString)
                        DispatchQueue.main.async {
                            GlobalData.shared.errorMessage = Mapper.errorMessageRemoteToLocal(errorResponseDecoded)
                        }
                        return futureCompletion(.failure(NetworkError.errorResponse(errorResponseDecoded)))
                    }
                    
                    if response.isStatusOK() {
                        return futureCompletion(.success(true))
                    }
                    return futureCompletion(.success(false))
                })
                .store(in: &self.cancellables)
        }
    }
    
    func postData<T:Codable, U:Codable>(to urlString: String, postData: T?, responseType: U.Type) -> Future<U, Error> {
        return Future<U, Error> { futureCompletion in
            guard let url = URL(string: urlString) else {
                return futureCompletion(.failure(NetworkError.badUrl))
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(self.bearerToken)", forHTTPHeaderField: "Authorization")
            request.setValue("\(self.notionVersion)", forHTTPHeaderField: "Notion-Version")
            
            
            if let postData = postData {
                guard let jsonData = try? JSONEncoder().encode(postData) else {
                    print(postData)
                    print("Error: Trying to convert model to JSON data")
                    return futureCompletion(.failure(NetworkError.encodingError))
                }
                
                request.httpBody = jsonData
            }
            
            URLSession.shared.dataTaskPublisher(for: request)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        futureCompletion(.failure(error))
                    }
                }, receiveValue: { output in
                    let data = output.data
                    let response = output.response
                    
                    if let errorResponseDecoded = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        print(urlString)
                        DispatchQueue.main.async {
                            GlobalData.shared.errorMessage = Mapper.errorMessageRemoteToLocal(errorResponseDecoded)
                        }
                        return futureCompletion(.failure(NetworkError.errorResponse(errorResponseDecoded)))
                    }
                    
                    guard let decoded = try? JSONDecoder().decode(U.self, from: data) else {
                        if response.isStatusOK() {
                            return futureCompletion(.failure(NetworkError.isStatusOK(true)))
                        }
                        
                        print(urlString)
                        print(String(data: data, encoding: .utf8) ?? "no data")
                        return futureCompletion(.failure(NetworkError.decodingError(data.jsonToString())))
                    }
                    
                    return futureCompletion(.success(decoded))
                })
                .store(in: &self.cancellables)
        }
    }
    
    func postData<T:Codable, U:Codable>(to urlString: String, postData: T?, completionResponse: @escaping (Result<U, NetworkError>, URLResponse?, Data?, Bool) -> Void) {
        guard let url = URL(string: urlString) else {
            return completionResponse(.failure(.badUrl), nil, nil, false)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("\(notionVersion)", forHTTPHeaderField: "Notion-Version")
        
        if let postData = postData {
            guard let jsonData = try? JSONEncoder().encode(postData) else {
                print(postData)
                print("Error: Trying to convert model to JSON data")
                return completionResponse(.failure(.encodingError), nil, nil, false)
            }
            
            request.httpBody = jsonData
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return completionResponse(.failure(.noData), response, nil, false)
            }
            
            if let errorResponseDecoded = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                print(urlString)
                DispatchQueue.main.async {
                    GlobalData.shared.errorMessage = Mapper.errorMessageRemoteToLocal(errorResponseDecoded)
                }
                return completionResponse(.failure(.errorResponse(errorResponseDecoded)), response, data, false)
            }
            
            guard let decoded = try? JSONDecoder().decode(U.self, from: data) else {
                if let response = response {
                    if response.isStatusOK() {
                        return completionResponse(.failure(.decodingError(data.jsonToString())), response, data, true)
                    }
                }
                
                print(urlString)
                print(String(data: data, encoding: .utf8) ?? "no data")
                return completionResponse(.failure(.decodingError(data.jsonToString())), response, data, false)
            }
            
            return completionResponse(.success(decoded), response, data, true)
        }.resume()
    }
    
    func patchData<T:Codable, U:Codable>(to urlString: String, patchData: T?, completionResponse: @escaping (Result<U, NetworkError>, URLResponse?, Data?, Bool) -> Void) {
        guard let url = URL(string: urlString) else {
            return completionResponse(.failure(.badUrl), nil, nil, false)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("\(notionVersion)", forHTTPHeaderField: "Notion-Version")
        
        if let patchData = patchData {
            guard let jsonData = try? JSONEncoder().encode(patchData) else {
                print(patchData)
                print("Error: Trying to convert model to JSON data")
                return completionResponse(.failure(.encodingError), nil, nil, false)
            }
            
            request.httpBody = jsonData
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return completionResponse(.failure(.noData), response, nil, false)
            }
            
            if let errorResponseDecoded = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                print(urlString)
                DispatchQueue.main.async {
                    GlobalData.shared.errorMessage = Mapper.errorMessageRemoteToLocal(errorResponseDecoded)
                }
                return completionResponse(.failure(.errorResponse(errorResponseDecoded)), response, data, false)
            }
            
            guard let decoded = try? JSONDecoder().decode(U.self, from: data) else {
                if let response = response {
                    if response.isStatusOK() {
                        return completionResponse(.failure(.decodingError(data.jsonToString())), response, data, true)
                    }
                }
                
                print(urlString)
                print(String(data: data, encoding: .utf8) ?? "no data")
                return completionResponse(.failure(.decodingError(data.jsonToString())), response, data, false)
            }
            
            return completionResponse(.success(decoded), response, data, true)
        }.resume()
    }
    
    func deleteData<T:Codable>(from urlString: String, completion: @escaping (Result<T, NetworkError>, URLResponse?, Data?, Bool) -> Void) {
        guard let url = URL(string: urlString) else {
            return completion(.failure(.badUrl), nil, nil, false)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("\(notionVersion)", forHTTPHeaderField: "Notion-Version")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(urlString)
                return completion(.failure(.noData), response, nil, false)
            }
            
            guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
                if let response = response {
                    if response.isStatusOK() {
                        return completion(.failure(.decodingError(data.jsonToString())), response, data, true)
                    }
                }
                print(urlString)
                print(String(data: data, encoding: .utf8) ?? "no data")
                
                if let errorResponseDecoded = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    DispatchQueue.main.async {
                        GlobalData.shared.errorMessage = Mapper.errorMessageRemoteToLocal(errorResponseDecoded)
                    }
                    return completion(.failure(.errorResponse(errorResponseDecoded)), response, data, false)
                }
                
                return completion(.failure(.errorMessage(data.jsonToString())), response, data, false)
            }
            completion(.success(decoded), response, data, true)
        }.resume()
    }
}

extension Data {
    func jsonToString() -> String {
        return String(data: self, encoding: .utf8) ?? "error encoding"
    }
    
    func decodedData<T:Codable>(type: T.Type) -> T? {
        guard let decoded = try? JSONDecoder().decode(T.self, from: self) else {
            print(String(data: self, encoding: .utf8) ?? "no data")
            return nil
        }
        
        return decoded
    }
}
