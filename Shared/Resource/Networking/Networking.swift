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
    case decodingError(String)
    case encodingError
    case noData
    case notLogin
    case errorMessage(String)
    case statusCode(Int?)
    case errorResponse(ErrorResponse)
    case dataNotComplete
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
    
    var cancelables = Set<AnyCancellable>()
    
    
    func handleOutput(_ output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse else {
                throw NetworkError.badUrl
            }
        
        if response.statusCode > 300 {
            if let errorResponseDecoded = try? JSONDecoder().decode(ErrorResponse.self, from: output.data) {
                DispatchQueue.main.async {
                    GlobalData.shared.errorMessage = Mapper.errorMessageRemoteToLocal(errorResponseDecoded)
                }
                throw NetworkError.errorResponse(errorResponseDecoded)
            }
        }
        return output.data
    }
    
    func getData<T:Codable>(from urlString: String, responseType: T.Type) throws -> AnyPublisher<T, Error> {
        guard let url = URL(string: urlString) else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("\(notionVersion)", forHTTPHeaderField: "Notion-Version")
        
        return Future<T, Error> { completion in
            URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap(self.handleOutput)
                .decode(type: T.self, decoder: JSONDecoder())
                .sink { completion in
                    
                } receiveValue: { value in
                    completion(.success(value))
                }
                .store(in: &self.cancelables)
        }.eraseToAnyPublisher()
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
    
    func postData<T:Codable, U:Codable>(to urlString: String, postData: T?, responseType: U.Type) throws -> AnyPublisher<U, Error> {
        guard let url = URL(string: urlString) else {
            throw NetworkError.badUrl
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
                throw NetworkError.encodingError
            }
            
            request.httpBody = jsonData
        }
                
        return Future<U, Error> { completion in
            URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap(self.handleOutput)
                .decode(type: U.self, decoder: JSONDecoder())
                .sink { completion in
                    
                } receiveValue: { value in
                    completion(.success(value))
                }
                .store(in: &self.cancelables)
        }.eraseToAnyPublisher()
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
    
    func patchData<T:Codable, U:Codable>(to urlString: String, patchData: T?, responseType: U.Type) throws -> AnyPublisher<U, Error> {
        guard let url = URL(string: urlString) else {
            throw NetworkError.badUrl
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
                throw NetworkError.encodingError
            }
            
            request.httpBody = jsonData
        }
        
        return Future<U, Error> { completion in
            URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap(self.handleOutput)
                .decode(type: U.self, decoder: JSONDecoder())
                .sink { completion in
                    
                } receiveValue: { value in
                    completion(.success(value))
                }
                .store(in: &self.cancelables)
        }.eraseToAnyPublisher()
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
    
    func deleteData<T:Codable>(from urlString: String) throws -> AnyPublisher<T, Error> {
        guard let url = URL(string: urlString) else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("\(notionVersion)", forHTTPHeaderField: "Notion-Version")
        
        return Future<T, Error> { completion in
            URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap(self.handleOutput)
                .decode(type: T.self, decoder: JSONDecoder())
                .sink { completion in
                    
                } receiveValue: { value in
                    completion(.success(value))
                }
                .store(in: &self.cancelables)
        }.eraseToAnyPublisher()
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
