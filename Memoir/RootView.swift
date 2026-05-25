//
//  RootView.swift
//  Memoir
//
//  Created by Pavel Ermakov on 21.05.26.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @State private var selectedTab: AppTab = .notes
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Notes", systemImage: Icon.note, value: .notes) {
                NotesListView()
            }
            
            Tab("Friends", systemImage: Icon.friends, value: .friends) {
                FriendsTabView()
            }
        }
        .tint(Color.memoirGold)
    }
}

#Preview {
    RootView()
        .modelContainer(for: [Note.self, Friend.self], inMemory: true)
}
