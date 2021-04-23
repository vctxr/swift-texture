//
//  AppDelegate.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import AsyncDisplayKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = ASNavigationController(rootViewController: SearchGIFVC())
        navigationController.navigationBar.prefersLargeTitles = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

