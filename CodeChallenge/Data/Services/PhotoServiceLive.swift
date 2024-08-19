//
//  PhotoServiceLive.swift
//  CodeChallenge
//
//  Created by Minh Vu on 16/08/2024.
//

import Foundation
import UIKit

final class PhotoServiceLive {
    private let requestManager: RequestManagerProtocol
    private let mapper = ModelMapper()

    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
}

private extension PhotoServiceLive {
    struct ModelMapper { }
}

extension PhotoServiceLive: PhotoService {
    
    func getPhotos(page: Int, limit: Int, completion: @escaping ([Photo]) -> Void) {
        requestManager.request([PhotoResponse].self, PhotoEndpoint.getPhotos(page: page, limit: limit)) { result in
            switch result {
            case .success(let data) :
                let photos = self.mapper.mapToDomain(from: data ?? [PhotoResponse]())
                completion(photos)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

private extension PhotoServiceLive.ModelMapper {
    func mapToDomain(from response: [PhotoResponse]) -> [Photo] {
        let photos = response.compactMap({ photoData in
            Photo(id: photoData.id ?? "",
                  author: photoData.author ?? "",
                  width: photoData.width ?? 0,
                  height: photoData.height ?? 0,
                  url: photoData.url ?? "",
                  downloadUrl: photoData.downloadUrl ?? "")
        })

        return photos
    }
}
