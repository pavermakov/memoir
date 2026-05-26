//
//  NoteEditorToolbar.swift
//  Memoir
//
//  Created by Pavel Ermakov on 21.05.26.
//

import SwiftUI

struct MemoryEditorToolbar: ToolbarContent {
    let isSaveButtonEnabled: Bool
    let onCancel: () -> Void
    let onSave: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(String(localized: "cancel"), action: onCancel)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button(String(localized: "save"), action: onSave)
                .fontWeight(.semibold)
                .disabled(!isSaveButtonEnabled)
        }
    }
}
