//
//  AppDelegate.swift
//  swift-login-system
//
//  Created by elif uyar on 2.11.2024.
//


import UIKit
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Firebase'i yapılandır
        FirebaseApp.configure()
        
        
        return true
    }
}
