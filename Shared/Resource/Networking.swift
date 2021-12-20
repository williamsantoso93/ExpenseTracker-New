//
//  Networking.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case decodingError(String)
    case encodingError
    case noData
    case notLogin
    case errorMessage(String)
    case statusCode(Int?)
    case errorResponse(ErrorResponse)
}

class Networking {
    let baseDatabase = "https://api.notion.com/v1/databases/"
    let basePage = "https://api.notion.com/v1/pages/"
    let bearerToken = "secret_yUINPEksksZKF6AMsyzhCKX03fSmKeD1FVblA41DoCu"
    let notionVersion = "2021-05-13"
    
    enum DatabaseID: String {
        case expenseDatabaseID = "695f266fc30d49fd8f430d17661c90a0"
        case incomeDatabaseID = "e5e0a95e277748b69def274e17e4f693"
        case yearMonthDatabaseID = "741f8897815542cba0f20110fe0c2adc"
        case typeDatabaseID = "030a40c2dfed4ed08d42950d25af4466"
    }
    
    enum SortDirection: String {
        case ascending = "ascending"
        case descending = "descending"
    }
    
    private init() { }
    
    static let shared = Networking()
    
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
                    return completion(.failure(.errorResponse(errorResponseDecoded)), response, data)
                }
                
                return completion(.failure(.errorMessage(data.jsonToString())), response, data)
            }
            completion(.success(decoded), response, data)
        }.resume()
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
    
    func postYearMonth() {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: DatabaseID.yearMonthDatabaseID.rawValue),
            properties: YearMonthPostProperty(
                name: TitleProperty(title: [Title(text: TextContent(content: "2024/01 January"))]),
                year: SingleSelectProperty(select: Select(name: "2024")),
                month: SingleSelectProperty(select: Select(name: "01 January"))
            )
        )
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            DispatchQueue.main.async {
                print(isSuccess)
            }
        }
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
