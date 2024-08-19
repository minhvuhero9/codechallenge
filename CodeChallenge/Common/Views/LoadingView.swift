//
//  LoadingVC.swift
//  CodeChallenge
//
//  Created by Minh Vu on 18/08/2024.
//

import UIKit

public struct ScreenSize {
    static let screenWidth: CGFloat = UIScreen.main.bounds.width,
               screenHeight: CGFloat = UIScreen.main.bounds.height
}

class LoadingView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.screenWidth, height: ScreenSize.screenHeight))
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.screenWidth, height: ScreenSize.screenHeight))
        self.setupView()
    }
}

extension LoadingView {
    private func setupView() {
        Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        indicator.startAnimating()
    }
}
