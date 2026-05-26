//
//  NoteEditorView.swift
//  Memoir
//
//  Created by Pavel Ermakov on 21.05.26.
//

import SwiftUI
import PhotosUI

struct MemoryEditorView: View {
    private let memory: Memory?
    let onCancel: () -> Void
    let onSave: (Memory) -> Void
    
    @State private var title: String
    @State private var message: String
    @State private var date: Date
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedPhotoData: [Data]
    @State private var isFriendsEditorVisible = false
    @State private var selectedFriends: [Friend]
    @FocusState private var focusField: MemoryField?
    
    private var isEditing: Bool { memory != nil }
    
    private var isMemoryReady: Bool {
        !title.isEmpty && !message.isEmpty
    }
    
    init(memory: Memory? = nil, onCancel: @escaping () -> Void, onSave: @escaping (Memory) -> Void) {
        self.memory = memory
        self.onCancel = onCancel
        self.onSave = onSave
        _title = State(initialValue: memory?.title ?? "")
        _message = State(initialValue: memory?.message ?? "")
        _date = State(initialValue: memory?.date ?? .now)
        _selectedFriends = State(initialValue: memory?.friends ?? [])
        _selectedPhotoData = State(initialValue: memory?.photos?.map(\.photoData) ?? [])
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
    
    private func saveMemory() {
        let photos = selectedPhotoData.isEmpty ? nil : selectedPhotoData.map { MemoryPhoto(photoData: $0) }
        
        if let memory {
            memory.title = title
            memory.message = message
            memory.date = date
            memory.friends = selectedFriends.isEmpty ? nil : selectedFriends
            memory.photos = photos
            onSave(memory)
        } else {
            let newMemory = Memory(
                title: title,
                date: date,
                message: message,
                friends: selectedFriends.isEmpty ? nil : selectedFriends,
                photos: photos
            )
            onSave(newMemory)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                MemoryTitleField(title: $title, date: $date)
                    .focused($focusField, equals: .title)
                
                MemoryMessageField(text: $message)
                    .focused($focusField, equals: .message)
                
                MemoryPhotosPicker(
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
            .navigationTitle(isEditing ? String(localized: "editMemory") : String(localized: "addNewMemory"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                MemoryEditorToolbar(
                    isSaveButtonEnabled: isMemoryReady,
                    onCancel: onCancel,
                    onSave: saveMemory
                )
            }
        }
    }
}

#Preview {
    MemoryEditorView(onCancel: {}, onSave: { _ in })
}
