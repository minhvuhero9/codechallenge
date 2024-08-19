//
//  NetworkError.swift
//  CodeChallenge
//
//  Created by Minh Vu on 16/08/2024.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidServerResponse
    case noData
    case decodeError

    public var errorDescription: String? {
        switch self {
        case .invalidServerResponse:
              return "The server returned an invalid response."
        case .invalidURL:
            return "URL string is malformed."
        case .noData:
            return "no data"
        case .decodeError:
            return "Decoding failed"
        }
    }
}
