//
//  UIImageView+Extension.swift
//  CodeChallenge
//
//  Created by Minh Vu on 19/08/2024.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, NSData>()
    
    private init() {}
    
    func getImage(forKey key: String) -> NSData? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func saveImage(_ image: NSData, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}

extension UIImageView {
    func setImage(_ imageURL: URL, placeholder: String, completion: (() -> Void)? = nil) {
        self.image = UIImage(named: placeholder)
        
        if let imageData = ImageCacheManager.shared.getImage(forKey: imageURL.absoluteString) {
            print("using cached images")
            guard let image = UIImage(data: imageData as Data) else { return }
            let resizedImage = self.resizeImage(image, targetSize: self.bounds.size)
            self.image = resizedImage
            completion?()
            return
        }
        
        let task = URLSession.shared.downloadTask(with: imageURL) { url, urlResponse, error in
            guard let url = url else {
                print("URL is nil")
                return
            }
            
            do {
                let data =  try Data(contentsOf: url)
                ImageCacheManager.shared.saveImage(data as NSData, forKey: imageURL.absoluteString)
                if let image = UIImage(data: data)  {
                    DispatchQueue.main.async {
                        let resizedImage = self.resizeImage(image, targetSize: self.bounds.size)
                        self.image = resizedImage
                        completion?()
                    }
                }
            } catch {
                
            }
        }
        task.resume()
    }
    
    private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio = size.width / size.height
        let height = targetSize.width / widthRatio
        
        let newSize = CGSize(width: targetSize.width, height: height)
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }
}
