//
//  Endpoint.swift
//  CodeChallenge
//
//  Created by Minh Vu on 15/08/2024.
//

import Foundation

public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]

public enum HTTPMethods: String {
    case GET
    case POST
    case DELETE
    case PATCH
    case PUT
}

public protocol Endpoint {
    var method: HTTPMethods { get }
    var baseURL: URL { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var urlParams: [String: String] { get }
    var headers: HTTPHeaders? { get }
}

extension Endpoint {
    func createURLRequest() throws -> URLRequest {
        var url = baseURL.appendingPathComponent(path)
        if method == .GET, let parameters = parameters {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            if let urlWithQuery = urlComponents?.url {
                url = urlWithQuery
            } else {
                //throw RequestError.invalidURL
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
                
        if method == .POST || method == .PUT, let parameters = parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
}
