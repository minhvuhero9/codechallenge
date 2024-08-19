//
//  RequestManagerTests.swift
//  CodeChallengeTests
//
//  Created by Minh Vu on 20/08/2024.
//

import XCTest
@testable import CodeChallenge

class APIManagerMock: APIManagerProtocol {
    var jsonFileName: String?
    
    func perform(_ request: Endpoint, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let fileName = self.jsonFileName else {
            completion(.failure(NSError(domain: "No file name", code: 0, userInfo: nil)))
            return
        }
        
        let bundle = Bundle.main
        
        guard let url = bundle.url(forResource: "mock", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            completion(.failure(NSError(domain: "Invalid file", code: 0, userInfo: nil)))
            return
        }
        
        completion(.success(data))
    }
}

struct RequestManagerMock: RequestManagerProtocol {
    
    let apiManagerMock: APIManagerMock
    
    init(apiManagerMock: APIManagerMock) {
        self.apiManagerMock = apiManagerMock
    }
    
    func request<T>(_ type: T.Type, _ request: CodeChallenge.Endpoint, completion: @escaping (Result<T?, CodeChallenge.NetworkError>) -> Void) where T : Decodable {
        apiManagerMock.perform(request) { result in
            switch result {
            case .success(let data):
                do {
                    let jsonDecoder: JSONDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedObject = try jsonDecoder.decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(let error):
                completion(.failure(.invalidServerResponse))
            }
        }
    }
    
}

final class RequestManagerTests: XCTestCase {
    
    private var requestManager: RequestManagerMock?
    private var apiManagerMock: APIManagerMock?
    
    override func setUp() {
        super.setUp()
        
        apiManagerMock = APIManagerMock()
        apiManagerMock?.jsonFileName = "mock"
        requestManager = RequestManagerMock(apiManagerMock: apiManagerMock!)
    }
    
    // Example test method
    func testSomeRequest() {
        // Use requestManager here
        requestManager?.request([PhotoResponse].self, PhotoEndpoint.getPhotos(page: 1, limit: 100), completion: { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data?.first?.author, "Alejandro Escamilla")
            case .failure(let error):
                print(error)
            }
        })
    }
}
