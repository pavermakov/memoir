//
//  RootView.swift
//  Memoir
//
//  Created by Pavel Ermakov on 21.05.26.
//

import SwiftUI
import SwiftData

@Observable
@MainActor
final class RootViewModel {
    var notes: [Note] = []
    
    func saveNote(title: String, message: String) {
        let newNote = Note(title: title, date: Date.now, message: message)
        notes.append(newNote)
    }
}

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Note.date, order: .reverse) private var notes: [Note]
    @State private var isEditorOpen = false
    
    private func saveNote(_ note: Note) {
        modelContext.insert(note)
    }
    
    private func deleteNotes(_ indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(notes[index])
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if notes.isEmpty {
                    VStack(spacing: 0) {
                        Spacer()
                        
                        VStack(spacing: 16) {
                            Image(systemName: Icon.note)
                                .font(.system(size: 40))
                                .foregroundStyle(Color.memoirGold.opacity(0.6))
                            
                            Text("No notes yet")
                                .font(.system(.title3, design: .serif).weight(.medium))
                                .foregroundStyle(Color.memoirInk)
                            
                            Text("Add a new note to get started.")
                                .font(.system(.subheadline, design: .serif))
                                .foregroundStyle(Color.memoirInk.opacity(0.4))
                        }
                        .frame(maxWidth: .infinity)
                        
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(notes) { note in
                            NoteListItem(note: note)
                        }
                        .onDelete (perform: deleteNotes)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .background(Color.memoirPaper)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(notes.isEmpty ? "" : "Notes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isEditorOpen = true
                    }) {
                        Label("Add Note", systemImage: Icon.addNote)
                    }
                }
            }
            .fullScreenCover(isPresented: $isEditorOpen) {
                NoteEditor(
                    onCancel: {
                        isEditorOpen = false
                    },
                    onSave: { note in
                        isEditorOpen = false
                        saveNote(note)
                    }
                )
            }
        }
    }
}

#Preview {
    RootView()
}
