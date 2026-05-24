//
//  NoteTitleField.swift
//  Memoir
//
//  Created by Pavel Ermakov on 21.05.26.
//

import SwiftUI

struct NoteTitleField: View {
    @Binding var title: String
    @Binding var date: Date
    @FocusState private var isFocused: Bool
    @State private var placeholder: String
    @State private var isDatePickerPresented = false
    
    private static let availablePlaceholders = [
        "Give it a title...",
        "What's on your mind?",
        "Name this moment…",
        "A thought, a memory…"
    ]
    
    init(title: Binding<String>, date: Binding<Date>) {
        self._title = title
        self._date = date
        self._placeholder = State(initialValue: Self.availablePlaceholders.randomElement() ?? "")
    }
    
    private var promptText: Text {
        Text(placeholder)
            .font(.system(.body, design: .serif))
            .foregroundColor(Color.memoirInk.opacity(0.3))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                HStack(spacing: 2) {
                    Text("Title")
                        .font(.system(.caption, design: .serif))
                        .foregroundStyle(Color.memoirInk.opacity(0.5))
                    
                    Text("*")
                        .font(.system(.caption, design: .serif))
                        .foregroundStyle(Color.memoirGold)
                }
                
                Spacer()
                
                Button {
                    isDatePickerPresented = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: Icon.calendar)
                        Text(date, format: .dateTime.month(.abbreviated).day().year())
                    }
                    .font(.system(.caption, design: .serif))
                    .foregroundStyle(Color.memoirGold)
                }
            }
            .padding(.horizontal, 4)
            
            TextField("", text: $title, prompt: promptText, axis: .vertical)
                .font(.system(.title2, design: .serif).weight(.medium))
                .foregroundStyle(Color.memoirInk)
                .tint(Color.memoirGold)
                .focused($isFocused)
                .lineLimit(1...3)
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
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
        .sheet(isPresented: $isDatePickerPresented) {
            NoteDatePicker(date: $date, isPresented: $isDatePickerPresented)
        }
    }
}

#Preview {
    VStack(spacing: 32) {
        NoteTitleField(title: .constant(""), date: .constant(.now))
        NoteTitleField(title: .constant("My First Memoir"), date: .constant(.now))
    }
    .padding(24)
    .background(Color.memoirPaper)
}
