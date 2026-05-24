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
    @State private var newFirstName = ""
    @State private var newLastName = ""
    
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
    
    var body: some View {
        NavigationStack {
            Group {
                if friends.isEmpty {
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
                } else {
                    List(friends) { friend in
                        Button {
                            toggleSelection(friend)
                        } label: {
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(Color.memoirGold.opacity(0.15))
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Text(friend.firstName.prefix(1).uppercased())
                                            .font(.system(.subheadline, design: .serif).weight(.medium))
                                            .foregroundStyle(Color.memoirGold)
                                    )
                                
                                Text("\(friend.firstName) \(friend.lastName)")
                                    .font(.system(.body, design: .serif))
                                    .foregroundStyle(Color.memoirInk)
                                
                                Spacer()
                                
                                if isSelected(friend) {
                                    Image(systemName: "checkmark.circle.fill")
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
                    Button("Add", systemImage: "plus") {
                        isAddingFriend = true
                    }
                    .foregroundStyle(Color.memoirGold)
                }
            }
            .alert("New Friend", isPresented: $isAddingFriend) {
                TextField("First name", text: $newFirstName)
                TextField("Last name", text: $newLastName)
                
                Button("Cancel", role: .cancel) {
                    newFirstName = ""
                    newLastName = ""
                }
                
                Button("Add") {
                    guard !newFirstName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    let friend = Friend(
                        firstName: newFirstName.trimmingCharacters(in: .whitespaces),
                        lastName: newLastName.trimmingCharacters(in: .whitespaces)
                    )
                    modelContext.insert(friend)
                    newFirstName = ""
                    newLastName = ""
                }
            } message: {
                Text("Enter their name to add them to your friends.")
            }
        }
    }
}

#Preview {
    FriendsListView(isPresented: .constant(true), selectedFriends: .constant([]))
        .modelContainer(for: Friend.self, inMemory: true)
}
