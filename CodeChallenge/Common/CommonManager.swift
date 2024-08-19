//
//  CommonManager.swift
//  CodeChallenge
//
//  Created by Minh Vu on 18/08/2024.
//

import Foundation
import UIKit

extension UIWindow {
    
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
}

class CommonManager {
    private static var loadingView: LoadingView?
}

extension CommonManager {
    public class func showLoading() {
        DispatchQueue.main.async {
            
            if self.loadingView == nil {
                self.loadingView = LoadingView()
                if let window = UIWindow.key, let loadingView = self.loadingView {
                    window.addSubview(loadingView)
                    loadingView.translatesAutoresizingMaskIntoConstraints = false
                    
                    guard let superview = loadingView.superview else {
                        return
                    }
                    
                    NSLayoutConstraint.activate([
                        loadingView.topAnchor.constraint(equalTo: superview.topAnchor),
                        loadingView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                        loadingView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                        loadingView.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
                    ])
                }
            }
        }
    }
    
    public class func hideLoading() {
        DispatchQueue.main.async {
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
        }
    }
}
