//
//  HomeVM.swift
//  CodeChallenge
//
//  Created by Minh Vu on 15/08/2024.
//

import Foundation
import UIKit

class HomeVM {
    var photoData: [Photo] = [Photo]()
    let photoService: PhotoService
    
    var filteredPhotos: [Photo] = []
    var isFiltering: Bool = false
    
    private var currentPage = 1
    private let itemsPerPage = 100
    
    var fetchDataSuccess: () -> Void = { }
    var fetchDataFailure: (String) -> Void = { _ in }
    var searchDataFailure: () -> Void = { }

    init(photoService: PhotoService) {
        self.photoService = photoService
    }
    
    func getListPhoto(isRefreshing: Bool = false) {
        if isRefreshing {
            currentPage = 1
        }
        
        CommonManager.showLoading()
        photoService.getPhotos(page: currentPage, limit: itemsPerPage) { [weak self] photos in
            guard let self = self else { return }
            if isRefreshing {
                self.photoData = photos
            } else {
                self.photoData.append(contentsOf: photos)
            }
            self.currentPage += 1
            self.fetchDataSuccess()
        }
    }
    
    func searchPhotos(by query: String) {
        if query.count > 15 {
            searchDataFailure()
            return
        }
        let validatedText = validateSearchText(query)
        isFiltering = true
        filteredPhotos = photoData.filter { photo in
            return photo.author.lowercased().contains(validatedText.lowercased()) || "\(photo.id)".contains(validatedText)
        }
        fetchDataSuccess()
    }
    
    func clearSearch() {
        isFiltering = false
        filteredPhotos = []
        fetchDataSuccess()
    }
    
    func validateSearchText(_ text: String) -> String {
        let withoutAccents = text.folding(options: .diacriticInsensitive, locale: .current)
        
        let emojiPattern = "[\\p{Emoji}\\p{Emoji_Presentation}\\p{Emoji_Modifier}\\p{Emoji_Modifier_Base}\\p{Emoji_Component}\\p{Extended_Pictographic}]"
        
        do {
            let emojiRegex = try NSRegularExpression(pattern: emojiPattern, options: [])
            let range = NSRange(location: 0, length: withoutAccents.utf16.count)
            let withoutEmojis = emojiRegex.stringByReplacingMatches(in: withoutAccents, options: [], range: range, withTemplate: "")
            
            let allowedCharacters = "a-zA-Z0-9!@#$%^&*():.,<>/\\[\\]? "
            let specialCharPattern = "[^\(allowedCharacters)]"
            let specialCharRegex = try NSRegularExpression(pattern: specialCharPattern, options: [])
            let finalValidatedText = specialCharRegex.stringByReplacingMatches(in: withoutEmojis, options: [], range: NSRange(location: 0, length: withoutEmojis.utf16.count), withTemplate: "")
            
            return finalValidatedText
        } catch {
            print("Error in regex: \(error)")
            return text
        }
    }
}
