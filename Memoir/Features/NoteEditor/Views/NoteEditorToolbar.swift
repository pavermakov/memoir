//
//  NoteEditorToolbar.swift
//  Memoir
//
//  Created by Pavel Ermakov on 21.05.26.
//

import SwiftUI

struct NoteEditorToolbar: ToolbarContent {
    let isSaveButtonEnabled: Bool
    let onCancel: () -> Void
    let onSave: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Cancel", action: onCancel)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button("Save", action: onSave)
                .fontWeight(.semibold)
                .disabled(!isSaveButtonEnabled)
        }
    }
}
