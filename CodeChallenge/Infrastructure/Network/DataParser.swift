//
//  DataParser.swift
//  CodeChallenge
//
//  Created by Minh Vu on 19/08/2024.
//

import Foundation

protocol DataParserProtocol {
    func parse<T: Decodable>(_ data: Data) throws -> T
}

class DataParser: DataParserProtocol {
    private var jsonDecoder: JSONDecoder
    
    init(jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = jsonDecoder
    }

    func parse<T: Decodable>(_ data: Data) throws -> T where T : Decodable {
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try jsonDecoder.decode(T.self, from: data)
    }
}
