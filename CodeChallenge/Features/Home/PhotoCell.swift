//
//  PhotoCell.swift
//  CodeChallenge
//
//  Created by Minh Vu on 15/08/2024.
//

import UIKit

class PhotoCell: UITableViewCell {
    @IBOutlet private weak var photoImage: UIImageView!
    @IBOutlet private weak var photoAuthor: UILabel!
    @IBOutlet private weak var photoSize: UILabel!
    
    var getImageSuccess: () -> Void = {  }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindData(data: Photo) {
        photoAuthor.text = data.author
        photoSize.text = "Size \(data.width)x\(data.height)"
        self.photoImage.setImage(URL(string: data.downloadUrl)!, placeholder: "placeholder") {
            self.getImageSuccess()
            self.layoutIfNeeded()
        }
    }

}
