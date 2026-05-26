//
//  NoteListItem.swift
//  Memoir
//
//  Created by Pavel Ermakov on 24.05.26.
//

import SwiftUI

struct MemoryListItem: View {
    let memory: Memory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let firstPhoto = memory.photos?.first, let image = firstPhoto.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .frame(maxWidth: .infinity)
                    .clipShape(.rect(cornerRadius: 8))
                    .overlay(alignment: .topTrailing) {
                        Text(memory.date, format: .dateTime.month(.abbreviated).day())
                            .font(.system(.caption2, design: .serif))
                            .bold()
                            .foregroundStyle(Color.memoirInk)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.ultraThinMaterial)
                            .clipShape(.capsule)
                            .padding(8)
                    }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                if memory.photos?.first == nil {
                    Text(memory.date, format: .dateTime.month(.abbreviated).day().year())
                        .font(.system(.caption, design: .serif))
                        .foregroundStyle(Color.memoirGold)
                }
                
                Text(memory.title)
                    .font(.system(.subheadline, design: .serif))
                    .bold()
                    .foregroundStyle(Color.memoirInk)
                    .lineLimit(2)
                
                if let friends = memory.friends, !friends.isEmpty {
                    FriendAvatarStack(friends: friends)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.memoirGold.opacity(0.08))
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.memoirGold.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    let sampleFriends = [
        Friend(firstName: "Alice", lastName: "M"),
        Friend(firstName: "Bob", lastName: "K"),
        Friend(firstName: "Clara", lastName: "S"),
        Friend(firstName: "Dan", lastName: "W"),
        Friend(firstName: "Eva", lastName: "L"),
    ]

    List {
        MemoryListItem(memory: Memory(
            title: "A Walk by the River",
            date: .now,
            message: "The sun was setting and the water reflected golden light across the path.",
            friends: Array(sampleFriends.prefix(2))
        ))

        MemoryListItem(memory: Memory(
            title: "Morning Coffee",
            date: .now.addingTimeInterval(-86400),
            message: "Simple pleasures.",
            friends: sampleFriends
        ))

        MemoryListItem(memory: Memory(
            title: "Quiet Evening",
            date: .now.addingTimeInterval(-172800),
            message: "Just me and a book."
        ))
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
    .background(Color.memoirPaper)
}
