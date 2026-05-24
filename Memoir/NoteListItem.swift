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
            HStack {
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
        }
        .padding(.vertical, 4)
        .listRowBackground(Color.clear)
        .listRowSeparatorTint(Color.memoirInk.opacity(0.08))
    }
}

#Preview {
    List {
        NoteListItem(note: Note(
            title: "A Walk by the River",
            date: .now,
            message: "The sun was setting and the water reflected golden light across the path. I thought about how moments like these slip away so quietly."
        ))
        
        NoteListItem(note: Note(
            title: "Morning Coffee",
            date: .now.addingTimeInterval(-86400),
            message: "Simple pleasures."
        ))
    }
    .listStyle(.plain)
    .background(Color.memoirPaper)
    .scrollContentBackground(.hidden)
}
