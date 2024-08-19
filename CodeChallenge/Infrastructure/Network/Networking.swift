//
//  Networking.swift
//  CodeChallenge
//
//  Created by Minh Vu on 15/08/2024.
//

import Foundation

protocol APIManagerProtocol {
    func perform(_ request: Endpoint, completion: @escaping (Result<Data, Error>) -> Void)
}

class APIManager: APIManagerProtocol {
    
    private let urlSession: URLSession
    
    private var images = NSCache<NSString, NSData>()
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func perform(_ request: Endpoint, completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            let request = try request.createURLRequest()
            let task = urlSession.dataTask(with: request) { data, response, error in
                completion(.success(data ?? Data()))
            }
            task.resume()
        } catch {
            completion(.failure(error.localizedDescription as! Error))
        }
    }
    
}

protocol RequestManagerProtocol {
    func request<T: Decodable>(_ type: T.Type, _ request: Endpoint, completion: @escaping (Result<T?, NetworkError>) -> Void)
}

class RequestManager: RequestManagerProtocol {
    
    let apiManager: APIManagerProtocol
    let parser: DataParserProtocol
    
    init
    (
        apiManager: APIManagerProtocol = APIManager(),
        parser: DataParserProtocol = DataParser()
    ) {
        self.apiManager = apiManager
        self.parser = parser
    }
    
    func request<T: Decodable>(_ type: T.Type ,_ request: Endpoint, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        apiManager.perform(request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedObject: T = try self.parser.parse(data)
                    completion(.success(decodedObject))
                } catch {
                    completion(.failure(.invalidServerResponse))
                }
            case .failure(_ ):
                completion(.failure(.noData))
            }
        }
    }
}
