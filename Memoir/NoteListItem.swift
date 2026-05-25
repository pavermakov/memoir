//
//  NoteListItem.swift
//  Memoir
//
//  Created by Pavel Ermakov on 24.05.26.
//

import SwiftUI

struct NoteListItem: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 0) {
                Text(note.title)
                    .font(.system(.headline, design: .serif))
                    .foregroundStyle(Color.memoirInk)
                    .lineLimit(1)
                
                Spacer()
                
                Text(note.date, format: .dateTime.month(.abbreviated).day())
                    .font(.system(.caption, design: .serif))
                    .foregroundStyle(Color.memoirGold)
            }
            
            Text(note.message)
                .font(.system(.subheadline, design: .serif))
                .foregroundStyle(Color.memoirInk.opacity(0.5))
                .lineLimit(2)
            
            if let friends = note.friends, !friends.isEmpty {
                FriendAvatarStack(friends: friends)
            }
        }
        .padding(.vertical, 4)
        .listRowBackground(Color.clear)
        .listRowSeparatorTint(Color.memoirInk.opacity(0.08))
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
        NoteListItem(note: Note(
            title: "A Walk by the River",
            date: .now,
            message: "The sun was setting and the water reflected golden light across the path. I thought about how moments like these slip away so quietly.",
            friends: Array(sampleFriends.prefix(2))
        ))

        NoteListItem(note: Note(
            title: "Morning Coffee",
            date: .now.addingTimeInterval(-86400),
            message: "Simple pleasures.",
            friends: sampleFriends
        ))

        NoteListItem(note: Note(
            title: "Quiet Evening",
            date: .now.addingTimeInterval(-172800),
            message: "Just me and a book."
        ))
    }
    .listStyle(.plain)
    .background(Color.memoirPaper)
    .scrollContentBackground(.hidden)
}
