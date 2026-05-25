//
//  FriendsListView.swift
//  Memoir
//
//  Created by Pavel Ermakov on 25.05.26.
//

import SwiftUI
import SwiftData

struct FriendsListView: View {
    @Binding var isPresented: Bool
    @Binding var selectedFriends: [Friend]
    @Query(sort: \Friend.firstName) private var friends: [Friend]
    @Environment(\.modelContext) private var modelContext
    @State private var isAddingFriend = false
    
    var body: some View {
        NavigationStack {
            Group {
                if friends.isEmpty {
                    FriendsEditorEmptyView()
                } else {
                    List(friends) { friend in
                        Button {
                            toggleSelection(friend)
                        } label: {
                            HStack(spacing: 12) {
                                if let profileImage = friend.profileImage {
                                    profileImage
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 36, height: 36)
                                        .clipShape(.circle)
                                } else {
                                    Circle()
                                        .fill(Color.memoirGold.opacity(0.15))
                                        .frame(width: 36, height: 36)
                                        .overlay(
                                            Text(friend.firstName.prefix(1).uppercased())
                                                .font(.system(.subheadline, design: .serif).weight(.medium))
                                                .foregroundStyle(Color.memoirGold)
                                        )
                                }
                                
                                Text("\(friend.firstName) \(friend.lastName)")
                                    .font(.system(.body, design: .serif))
                                    .foregroundStyle(Color.memoirInk)
                                
                                Spacer()
                                
                                if isSelected(friend) {
                                    Image(systemName: Icon.checkmark)
                                        .foregroundStyle(Color.memoirGold)
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .background(Color.memoirPaper)
            .navigationTitle("Friends")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") {
                        isPresented = false
                    }
                    .bold()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", systemImage: Icon.plus) {
                        isAddingFriend = true
                    }
                    .foregroundStyle(Color.memoirGold)
                }
            }
            .sheet(isPresented: $isAddingFriend) {
                AddFriendSheet(isPresented: $isAddingFriend)
            }
        }
    }
}

extension FriendsListView {
    private func isSelected(_ friend: Friend) -> Bool {
        selectedFriends.contains { $0.persistentModelID == friend.persistentModelID }
    }
    
    private func toggleSelection(_ friend: Friend) {
        if let index = selectedFriends.firstIndex(where: { $0.persistentModelID == friend.persistentModelID }) {
            selectedFriends.remove(at: index)
        } else {
            selectedFriends.append(friend)
        }
    }
}

#Preview {
    FriendsListView(isPresented: .constant(true), selectedFriends: .constant([]))
        .modelContainer(for: Friend.self, inMemory: true)
}
