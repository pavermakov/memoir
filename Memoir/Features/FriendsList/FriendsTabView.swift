//
//  FriendsTabView.swift
//  Memoir
//
//  Created by Pavel Ermakov on 25.05.26.
//

import SwiftUI
import SwiftData

struct FriendsTabView: View {
    @Query(sort: \Friend.firstName) private var friends: [Friend]
    @Environment(\.modelContext) private var modelContext
    @State private var isAddingFriend = false
    @State private var selectedFriend: Friend?
    
    var body: some View {
        NavigationStack {
            Group {
                if friends.isEmpty {
                    FriendsEditorEmptyView()
                } else {
                    List {
                        ForEach(friends) { friend in
                            Button {
                                selectedFriend = friend
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
                                }
                            }
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteFriends)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .background(Color.memoirPaper)
            .navigationTitle(friends.isEmpty ? "" : String(localized: "friends"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(localized: "addFriend"), systemImage: Icon.plus) {
                        isAddingFriend = true
                    }
                    .foregroundStyle(Color.memoirGold)
                }
            }
            .sheet(isPresented: $isAddingFriend) {
                AddFriendSheet(isPresented: $isAddingFriend)
            }
            .sheet(item: $selectedFriend) { friend in
                FriendProfilePopup(friend: friend)
            }
        }
    }
    
    private func deleteFriends(_ indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(friends[index])
        }
    }
}

#Preview {
    FriendsTabView()
        .modelContainer(for: Friend.self, inMemory: true)
}
