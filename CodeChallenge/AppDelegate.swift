//
//  AppDelegate.swift
//  CodeChallenge
//
//  Created by Minh Vu on 15/08/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        let requestManger = RequestManager()
        let photoService = PhotoServiceLive(requestManager: requestManger)
        let vm = HomeVM(photoService: photoService)
        let homeVC = HomeVC(vm: vm)
        navigationController.pushViewController(homeVC, animated: true)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
}

