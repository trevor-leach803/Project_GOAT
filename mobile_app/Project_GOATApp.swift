//
//  Project_GOATApp.swift
//  Project_GOAT
//
//  Created by Trevor Leach on 7/26/23.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Project_GOATApp: App {
    @StateObject private var authManager = AuthManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            LoginPage()
                .environmentObject(authManager)
        }
    }
}
