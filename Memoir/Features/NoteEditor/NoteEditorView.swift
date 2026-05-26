//
//  NoteEditorView.swift
//  Memoir
//
//  Created by Pavel Ermakov on 21.05.26.
//

import SwiftUI
import PhotosUI

struct NoteEditorView: View {
    private let note: Note?
    let onCancel: () -> Void
    let onSave: (Note) -> Void
    
    @State private var title: String
    @State private var message: String
    @State private var date: Date
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedPhotos: [NotePhoto] = []
    @State private var isFriendsEditorVisible = false
    @State private var selectedFriends: [Friend]
    @FocusState private var focusField: NoteField?
    
    private var isEditing: Bool { note != nil }
    
    private var isNoteReady: Bool {
        !title.isEmpty && !message.isEmpty
    }
    
    init(note: Note? = nil, onCancel: @escaping () -> Void, onSave: @escaping (Note) -> Void) {
        self.note = note
        self.onCancel = onCancel
        self.onSave = onSave
        _title = State(initialValue: note?.title ?? "")
        _message = State(initialValue: note?.message ?? "")
        _date = State(initialValue: note?.date ?? .now)
        _selectedFriends = State(initialValue: note?.friends ?? [])
    }
    
    func loadSelectedPhotos(_ items: [PhotosPickerItem]) async {
        let newItemIDs: Set<String> = Set(items.compactMap(\.itemIdentifier))
        let loadedIDs: Set<String> = Set(selectedPhotos.map(\.id))

        selectedPhotos.removeAll { !newItemIDs.contains($0.id) }
        
        let newItems: [PhotosPickerItem] = items.filter { item in
            guard let id = item.itemIdentifier else { return false }
            return !loadedIDs.contains(id)
        }
        
        for item in newItems {
            if let id = item.itemIdentifier,
               let image = try? await item.loadTransferable(type: Image.self) {
                selectedPhotos.append(NotePhoto(id: id, image: image))
            }
        }
    }
    
    private func saveNote() {
        if let note {
            note.title = title
            note.message = message
            note.date = date
            note.friends = selectedFriends.isEmpty ? nil : selectedFriends
            onSave(note)
        } else {
            let newNote = Note(
                title: title,
                date: date,
                message: message,
                friends: selectedFriends.isEmpty ? nil : selectedFriends
            )
            onSave(newNote)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                NoteTitleField(title: $title, date: $date)
                    .focused($focusField, equals: .title)
                
                NoteMessageField(text: $message)
                    .focused($focusField, equals: .message)
                
                NotePhotosPicker(
                    selectedItems: $selectedItems,
                    selectedPhotos: $selectedPhotos
                )
                .onChange(of: selectedItems) { _, newValue in
                    Task {
                        focusField = nil
                        await loadSelectedPhotos(newValue)
                    }
                }
                
                AddPeopleButton {
                    isFriendsEditorVisible = true
                }
                .sheet(isPresented: $isFriendsEditorVisible) {
                    FriendsListView(
                        isPresented: $isFriendsEditorVisible,
                        selectedFriends: $selectedFriends
                    )
                }
                
                if !selectedFriends.isEmpty {
                    SelectedFriendsView(selectedFriends: $selectedFriends)
                }
            }
            .contentMargins(24, for: .scrollContent)
            .background(Color.memoirPaper)
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle(isEditing ? "Edit note" : "Add new note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                NoteEditorToolbar(
                    isSaveButtonEnabled: isNoteReady,
                    onCancel: onCancel,
                    onSave: saveNote
                )
            }
        }
    }
}

#Preview {
    NoteEditorView(onCancel: {}, onSave: { _ in })
}
