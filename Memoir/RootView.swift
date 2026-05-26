//
//  RootView.swift
//  Memoir
//
//  Created by Pavel Ermakov on 21.05.26.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @State private var selectedTab: AppTab = .memories
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(String(localized: "memories"), systemImage: Icon.memory, value: .memories) {
                MemoriesListView()
            }
            
            Tab(String(localized: "friends"), systemImage: Icon.friends, value: .friends) {
                FriendsTabView()
            }
        }
        .tint(Color.memoirGold)
    }
}

#Preview {
    RootView()
        .modelContainer(for: [Memory.self, Friend.self], inMemory: true)
}
