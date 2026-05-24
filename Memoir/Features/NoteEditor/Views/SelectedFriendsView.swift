//
//  SelectedFriendsView.swift
//  Memoir
//
//  Created by Pavel Ermakov on 25.05.26.
//

import SwiftUI
import SwiftData

struct SelectedFriendsView: View {
    @Binding var selectedFriends: [Friend]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: Icon.addPeople)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.memoirGold)
                
                Text("\(selectedFriends.count) friend\(selectedFriends.count == 1 ? "" : "s")")
                    .font(.system(.subheadline, design: .serif))
                    .foregroundStyle(Color.memoirInk.opacity(0.6))
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(selectedFriends) { friend in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.memoirGold.opacity(0.15))
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Text(friend.firstName.prefix(1).uppercased())
                                        .font(.system(.caption2, design: .serif).weight(.medium))
                                        .foregroundStyle(Color.memoirGold)
                                )
                            
                            Text(friend.firstName)
                                .font(.system(.subheadline, design: .serif))
                                .foregroundStyle(Color.memoirInk)
                            
                            Button {
                                withAnimation {
                                    selectedFriends.removeAll {
                                        $0.persistentModelID == friend.persistentModelID
                                    }
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundStyle(Color.memoirInk.opacity(0.3))
                            }
                        }
                        .padding(.leading, 4)
                        .padding(.trailing, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.memoirGold.opacity(0.1))
                        )
                        .overlay(
                            Capsule()
                                .strokeBorder(Color.memoirGold.opacity(0.25), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 16)
            }
            .scrollIndicators(.hidden)
            .padding(.bottom, 14)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.memoirInk.opacity(0.03))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.memoirInk.opacity(0.12), lineWidth: 1)
        )
    }
}
