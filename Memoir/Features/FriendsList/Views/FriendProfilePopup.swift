//
//  FriendProfilePopup.swift
//  Memoir
//
//  Created by Pavel Ermakov on 25.05.26.
//

import SwiftUI

struct FriendProfilePopup: View {
    let friend: Friend
    @State private var isEditing = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()
                
                if let profileImage = friend.profileImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(.circle)
                } else {
                    Circle()
                        .fill(Color.memoirGold.opacity(0.15))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Text(friend.firstName.prefix(1).uppercased())
                                .font(.system(.largeTitle, design: .serif).weight(.medium))
                                .foregroundStyle(Color.memoirGold)
                        )
                }
                
                Text("\(friend.firstName) \(friend.lastName)")
                    .font(.system(.title3, design: .serif).weight(.medium))
                    .foregroundStyle(Color.memoirInk)
                
                Button("Edit", systemImage: Icon.edit) {
                    isEditing = true
                }
                .font(.system(.subheadline, design: .serif))
                .foregroundStyle(Color.memoirGold)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.memoirPaper)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .bold()
                    .foregroundStyle(Color.memoirGold)
                }
            }
            .sheet(isPresented: $isEditing) {
                EditFriendSheet(friend: friend)
            }
        }
        .presentationDetents([.medium])
    }
}
