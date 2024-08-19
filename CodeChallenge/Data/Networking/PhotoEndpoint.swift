//
//  PhotoEndpoint.swift
//  CodeChallenge
//
//  Created by Minh Vu on 15/08/2024.
//

import Foundation

enum PhotoEndpoint: Endpoint {
    case getPhotos(page: Int, limit: Int)
}

extension PhotoEndpoint {
    var method: HTTPMethods {
        switch self {
            case .getPhotos: 
                return .GET
        }
    }
    
    var baseURL: URL {
        switch self {
            case .getPhotos: 
            return URL(string: ApiConstants.baseURL) ?? URL(fileURLWithPath: "")
        }
    }
    
    var path: String {
        switch self {
            case .getPhotos: 
                return "/list"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getPhotos(let page, let limit):
            return [
                "page": String(page),
                "limit": String(limit)
            ]
        }
    }
    
    var urlParams: [String : String] {
        [:]
    }

    var headers: HTTPHeaders? {
        [:]
    }
}
