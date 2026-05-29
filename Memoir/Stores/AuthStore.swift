//
//  AuthStore.swift
//  Memoir
//
//  Created by Pavel Ermakov on 27.05.26.
//

import Foundation
import FirebaseAuth

@Observable
@MainActor
final class AuthStore {
    var user: User? = nil
    var isSignedIn: Bool = false
    
    init() {
        self.user = Auth.auth().currentUser
        self.isSignedIn = user != nil
    }
    
    func signIn(email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        user = result.user
        isSignedIn = true
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        user = nil
        isSignedIn = false
    }
}
