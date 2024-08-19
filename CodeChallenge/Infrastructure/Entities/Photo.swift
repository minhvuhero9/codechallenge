//
//  Photo.swift
//  CodeChallenge
//
//  Created by Minh Vu on 15/08/2024.
//

import Foundation

struct Photo: Equatable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let author: String
    let width: Int
    let height: Int
    let url: String
    let downloadUrl: String
}
