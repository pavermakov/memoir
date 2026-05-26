//
//  NoteMessageField.swift
//  Memoir
//
//  Created by Pavel Ermakov on 21.05.26.
//

import SwiftUI

struct MemoryMessageField: View {
    @Binding var text: String
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 2) {
                Text("Message")
                    .font(.system(.caption, design: .serif))
                    .foregroundStyle(Color.memoirInk.opacity(0.5))
                
                Text("*")
                    .font(.system(.caption, design: .serif))
                    .foregroundStyle(Color.memoirGold)
            }
            .padding(.leading, 4)
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text("Start writing...")
                        .font(.system(.body, design: .serif))
                        .foregroundStyle(Color.memoirInk.opacity(0.3))
                        .padding(.top, 14)
                        .padding(.leading, 16)
                        .allowsHitTesting(false)
                }
                
                TextEditor(text: $text)
                    .font(.system(.body, design: .serif))
                    .foregroundStyle(Color.memoirInk)
                    .tint(Color.memoirGold)
                    .focused($isFocused)
                    .scrollContentBackground(.hidden)
                    .lineSpacing(6)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    
            }
            .frame(minHeight: 200, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.memoirInk.opacity(0.03))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        isFocused ? Color.memoirGold : Color.memoirInk.opacity(0.12),
                        lineWidth: isFocused ? 1.5 : 1
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

#Preview {
    MemoryMessageField(text: .constant("Message"))
}
