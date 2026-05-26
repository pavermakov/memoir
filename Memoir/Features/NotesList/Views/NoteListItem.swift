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
        VStack(alignment: .leading, spacing: 12) {
            Text(note.date, format: .dateTime.month(.abbreviated).day().year())
                .font(.system(.caption, design: .serif))
                .foregroundStyle(Color.memoirGold)
            
            Text(note.title)
                .font(.system(.headline, design: .serif))
                .foregroundStyle(Color.memoirInk)
                .lineLimit(2)
            
            if let friends = note.friends, !friends.isEmpty {
                FriendAvatarStack(friends: friends)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.memoirInk.opacity(0.03))
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.memoirInk.opacity(0.08), lineWidth: 1)
        )
//        .listRowSeparator(.hidden)
//        .listRowBackground(Color.memoirPaper)
//        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
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
            message: "The sun was setting and the water reflected golden light across the path.",
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
    .scrollContentBackground(.hidden)
    .background(Color.memoirPaper)
}
