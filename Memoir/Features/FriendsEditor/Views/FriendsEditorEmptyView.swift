//
//  FriendsEditorEmptyView.swift
//  Memoir
//
//  Created by Pavel Ermakov on 25.05.26.
//

import SwiftUI

struct FriendsEditorEmptyView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: Icon.addPeople)
                .font(.system(size: 40))
                .foregroundStyle(Color.memoirGold.opacity(0.6))
            
            Text("No friends yet")
                .font(.system(.title3, design: .serif).weight(.medium))
                .foregroundStyle(Color.memoirInk)
            
            Text("Friends you add will appear here.")
                .font(.system(.subheadline, design: .serif))
                .foregroundStyle(Color.memoirInk.opacity(0.4))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    FriendsEditorEmptyView()
}
