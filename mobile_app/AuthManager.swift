//
//  AuthManager.swift
//  Project_GOAT
//
//  Created by Trevor Leach on 9/4/23.
//

import Foundation
import SwiftUI
import Firebase

class AuthManager: ObservableObject {
    @Published var isUserAuthenticated = false
    init() {
        Auth.auth().addStateDidChangeListener{ (_, user) in
            self.isUserAuthenticated = user != nil
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
