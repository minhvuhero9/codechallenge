//
//  PhotoResponse.swift
//  CodeChallenge
//
//  Created by Minh Vu on 16/08/2024.
//

import Foundation

struct PhotoResponse: Decodable {
    let id: String?
    let author: String?
    let width: Int?
    let height: Int?
    let url: String?
    let downloadUrl: String?
}
