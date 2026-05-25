//
//  FriendAvatarStack.swift
//  Memoir
//
//  Created by Pavel Ermakov on 25.05.26.
//

import SwiftUI

struct FriendAvatarStack: View {
    let friends: [Friend]

    private let avatarSize: CGFloat = 24
    private let maxVisible = 3

    private var visibleFriends: [Friend] {
        Array(friends.prefix(maxVisible))
    }

    private var overflowCount: Int {
        max(friends.count - maxVisible, 0)
    }

    var body: some View {
        HStack(spacing: 2) {
            HStack(spacing: -8) {
                ForEach(visibleFriends.enumerated(), id: \.element.id) { index, friend in
                    FriendAvatarCircle(friend: friend)
                        .zIndex(Double(maxVisible - index))
                }
            }
            
            if overflowCount > 0 {
                Text("+\(overflowCount)")
                    .font(.system(.caption2, design: .serif).weight(.medium))
                    .foregroundStyle(Color.memoirGold)
            }
        }
    }
}

private struct FriendAvatarCircle: View {
    let friend: Friend
    private let size: CGFloat = 24

    var body: some View {
        Group {
            if let profileImage = friend.profileImage {
                profileImage
                    .resizable()
                    .scaledToFill()
            } else {
                Circle()
                    .fill(Color(red: 0.93, green: 0.90, blue: 0.85))
                    .overlay(
                        Text(friend.firstName.prefix(1).uppercased())
                            .font(.system(.caption2, design: .serif).weight(.medium))
                            .foregroundStyle(Color.memoirGold)
                    )
            }
        }
        .frame(width: size, height: size)
        .clipShape(.circle)
        .overlay(
            Circle()
                .strokeBorder(Color.memoirPaper, lineWidth: 1.5)
        )
    }
}
