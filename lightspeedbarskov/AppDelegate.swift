//
//  AppDelegate.swift
//  lightspeedbarskov
//
//  Created by flappa on 04.11.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let initial = ProductListBuilder().makeScene()
        showModule(for: window!, controller: initial)
        
        return true
    }


}

extension AppDelegate {
    
    private func showModule(for window: UIWindow, controller: UIViewController) {
        let initial: UIViewController = controller
        window.rootViewController = initial
    }
    
    
}

