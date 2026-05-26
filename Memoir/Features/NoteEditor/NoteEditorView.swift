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
    @State private var selectedPhotoData: [Data]
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
        _selectedPhotoData = State(initialValue: note?.photos?.map(\.photoData) ?? [])
    }
    
    func loadSelectedPhotos(_ items: [PhotosPickerItem]) async {
        var newData: [Data] = []
        
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self) {
                newData.append(data)
            }
        }
        
        selectedPhotoData = newData
    }
    
    private func saveNote() {
        let photos = selectedPhotoData.isEmpty ? nil : selectedPhotoData.map { NotePhoto(photoData: $0) }
        
        if let note {
            note.title = title
            note.message = message
            note.date = date
            note.friends = selectedFriends.isEmpty ? nil : selectedFriends
            note.photos = photos
            onSave(note)
        } else {
            let newNote = Note(
                title: title,
                date: date,
                message: message,
                friends: selectedFriends.isEmpty ? nil : selectedFriends,
                photos: photos
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
                    selectedPhotoData: $selectedPhotoData
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
