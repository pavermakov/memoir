//
//  NotesListView.swift
//  Memoir
//
//  Created by Pavel Ermakov on 25.05.26.
//

import SwiftUI
import SwiftData

struct NotesListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Note.date, order: .reverse) private var notes: [Note]
    @State private var isEditorOpen = false
    @State private var selectedNote: Note?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if notes.isEmpty {
                    ContentUnavailableView {
                        Label {
                            Text("No notes yet")
                                .font(.system(.title3, design: .serif))
                                .fontWeight(.medium)
                                .foregroundStyle(Color.memoirInk)
                        } icon: {
                            Image(systemName: Icon.note)
                                .foregroundStyle(Color.memoirGold.opacity(0.6))
                        }
                    } description: {
                        Text("Add a new note to get started.")
                            .font(.system(.subheadline, design: .serif))
                            .foregroundStyle(Color.memoirInk.opacity(0.4))
                    }
                } else {
                    List {
                        ForEach(notes) { note in
                            Button {
                                selectedNote = note
                            } label: {
                                NoteListItem(note: note)
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete(perform: deleteNotes)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.memoirPaper)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
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
                    Button("Add Note", systemImage: Icon.addNote) {
                        isEditorOpen = true
                    }
                }
            }
            .fullScreenCover(isPresented: $isEditorOpen) {
                NoteEditorView(
                    onCancel: {
                        isEditorOpen = false
                    },
                    onSave: { note in
                        isEditorOpen = false
                        modelContext.insert(note)
                    }
                )
            }
            .fullScreenCover(item: $selectedNote) { note in
                NotePreviewView(note: note) {
                    selectedNote = nil
                }
            }
        }
    }
    
    private func deleteNotes(_ indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(notes[index])
        }
    }
}

#Preview {
    NotesListView()
        .modelContainer(for: [Note.self, Friend.self], inMemory: true)
}
