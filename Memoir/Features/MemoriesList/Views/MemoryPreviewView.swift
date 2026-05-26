//
//  NotePreviewView.swift
//  Memoir
//
//  Created by Pavel Ermakov on 25.05.26.
//

import SwiftUI

struct MemoryPreviewView: View {
    let memory: Memory
    let onDismiss: () -> Void
    
    @State private var isEditing = false
    @State private var fullScreenPhoto: MemoryPhoto?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(memory.date, format: .dateTime.month(.wide).day().year())
                            .font(.system(.subheadline, design: .serif))
                            .foregroundStyle(Color.memoirGold)
                        
                        Text(memory.title)
                            .font(.system(.title, design: .serif).weight(.medium))
                            .foregroundStyle(Color.memoirInk)
                        
                        Text(memory.message)
                            .font(.system(.body, design: .serif))
                            .foregroundStyle(Color.memoirInk.opacity(0.8))
                            .lineSpacing(6)
                    }
                    .padding(.horizontal, 24)
                    
                    if let photos = memory.photos, !photos.isEmpty {
                        ScrollView(.horizontal) {
                            HStack(spacing: 12) {
                                ForEach(photos) { photo in
                                    if let image = photo.image {
                                        Button {
                                            fullScreenPhoto = photo
                                        } label: {
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 200, height: 200)
                                                .clipShape(.rect(cornerRadius: 12))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollIndicators(.hidden)
                        .scrollTargetBehavior(.viewAligned)
                        .contentMargins(.horizontal, 24, for: .scrollContent)
                    }
                    
                    if let friends = memory.friends, !friends.isEmpty {
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
                        .padding(.horizontal, 24)
                    }
                }
                .frame(maxWidth: .infinity)
            }
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
                MemoryEditorView(
                    memory: memory,
                    onCancel: {
                        isEditing = false
                    },
                    onSave: { _ in
                        isEditing = false
                    }
                )
            }
            .fullScreenCover(item: $fullScreenPhoto) { photo in
                if let image = photo.image {
                    FullScreenImageView(image: image) {
                        fullScreenPhoto = nil
                    }
                }
            }
        }
    }
}
