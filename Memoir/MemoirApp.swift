//
//  MemoirApp.swift
//  Memoir
//
//  Created by Pavel Ermakov on 21.05.26.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct MemoirApp: App {
    @State private var authStore: AuthStore
    
    init() {
        FirebaseApp.configure()
        _authStore = State(initialValue: AuthStore())
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .environment(authStore)
        .modelContainer(for: [Memory.self, Friend.self, MemoryPhoto.self])
    }
}
