//
//  PasswordField.swift
//  Memoir
//
//  Created by Pavel Ermakov on 27.05.26.
//

import SwiftUI

struct PasswordField: View {
    let prompt: LocalizedStringKey
    @Binding var text: String
    @State private var maskedText = ""

    var body: some View {
        TextField(prompt, text: $maskedText)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .onChange(of: maskedText) { oldValue, newValue in
                updatePassword(oldValue: oldValue, newValue: newValue)
            }
    }

    private func updatePassword(oldValue: String, newValue: String) {
        let oldCount = oldValue.count
        let newCount = newValue.count

        if newCount > oldCount {
            // Characters were added
            let addedStartIndex = newValue.index(newValue.startIndex, offsetBy: oldCount)
            let addedChars = String(newValue[addedStartIndex...])
            text.append(addedChars)
            maskedText = String(repeating: "●", count: text.count)
        } else if newCount < oldCount {
            // Characters were deleted
            let removedCount = oldCount - newCount
            let endIndex = text.index(text.endIndex, offsetBy: -removedCount)
            text = String(text[text.startIndex..<endIndex])
            maskedText = String(repeating: "●", count: text.count)
        }
    }
}
