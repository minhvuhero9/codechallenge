//
//  PhotoService.swift
//  CodeChallenge
//
//  Created by Minh Vu on 16/08/2024.
//

import Foundation
import UIKit

protocol PhotoService {
    func getPhotos(page: Int, limit: Int, completion: @escaping ([Photo]) -> Void)
}
