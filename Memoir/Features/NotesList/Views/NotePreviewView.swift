//
//  NotePreviewView.swift
//  Memoir
//
//  Created by Pavel Ermakov on 25.05.26.
//

import SwiftUI

struct NotePreviewView: View {
    let note: Note
    let onDismiss: () -> Void
    
    @State private var isEditing = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(note.date, format: .dateTime.month(.wide).day().year())
                            .font(.system(.subheadline, design: .serif))
                            .foregroundStyle(Color.memoirGold)
                        
                        Text(note.title)
                            .font(.system(.title, design: .serif).weight(.medium))
                            .foregroundStyle(Color.memoirInk)
                        
                        Text(note.message)
                            .font(.system(.body, design: .serif))
                            .foregroundStyle(Color.memoirInk.opacity(0.8))
                            .lineSpacing(6)
                    }
                    
                    
                    
                    if let friends = note.friends, !friends.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("With")
                                .font(.system(.caption, design: .serif))
                                .foregroundStyle(Color.memoirInk.opacity(0.4))
                            
                            FlowLayout(spacing: 16) {
                                ForEach(friends) { friend in
                                    VStack(spacing: 6) {
                                        FriendAvatarCircle(friend: friend, size: 56)
                                        
                                        Text(friend.firstName)
                                            .font(.system(.caption2, design: .serif))
                                            .foregroundStyle(Color.memoirInk.opacity(0.6))
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .contentMargins(24, for: .scrollContent)
            .background(Color.memoirPaper)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done", action: onDismiss)
                        .bold()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit", systemImage: Icon.edit) {
                        isEditing = true
                    }
                    .foregroundStyle(Color.memoirGold)
                }
            }
            .fullScreenCover(isPresented: $isEditing) {
                NoteEditorView(
                    note: note,
                    onCancel: {
                        isEditing = false
                    },
                    onSave: { _ in
                        isEditing = false
                    }
                )
            }
        }
    }
}
