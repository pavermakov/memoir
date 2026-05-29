//
//  RootView.swift
//  Memoir
//
//  Created by Pavel Ermakov on 21.05.26.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(AuthStore.self) private var authStore: AuthStore
    @State private var selectedTab: AppTab = .memories
    
    var body: some View {
        Group {
            if authStore.isSignedIn {
                TabView(selection: $selectedTab) {
                    Tab(String(localized: "memories"), systemImage: Icon.memory, value: .memories) {
                        MemoriesListView()
                    }
                    
                    Tab(String(localized: "friends"), systemImage: Icon.friends, value: .friends) {
                        FriendsTabView()
                    }
                    
                    Tab(String(localized: "settings"), systemImage: Icon.settings, value: .settings) {
                        SettingsView()
                    }
                }
                .tint(Color.memoirGold)
            } else {
                SignInView()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: authStore.isSignedIn)
        .onChange(of: authStore.isSignedIn) {
            if !authStore.isSignedIn {
                selectedTab = .memories
            }
        }
    }
}

#Preview {
    RootView()
        .modelContainer(for: [Memory.self, Friend.self], inMemory: true)
}
