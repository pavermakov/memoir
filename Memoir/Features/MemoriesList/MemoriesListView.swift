//
//  NotesListView.swift
//  Memoir
//
//  Created by Pavel Ermakov on 25.05.26.
//

import SwiftUI
import SwiftData

struct MemoriesListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Memory.date, order: .reverse) private var memories: [Memory]
    @State private var isEditorOpen = false
    @State private var selectedMemory: Memory?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if memories.isEmpty {
                    ContentUnavailableView {
                        Label {
                            Text("No memories yet")
                                .font(.system(.title3, design: .serif))
                                .fontWeight(.medium)
                                .foregroundStyle(Color.memoirInk)
                        } icon: {
                            Image(systemName: Icon.memory)
                                .foregroundStyle(Color.memoirGold.opacity(0.6))
                        }
                    } description: {
                        Text("Add a new memory to get started.")
                            .font(.system(.subheadline, design: .serif))
                            .foregroundStyle(Color.memoirInk.opacity(0.4))
                    }
                } else {
                    List {
                        ForEach(memories) { memory in
                            Button {
                                selectedMemory = memory
                            } label: {
                                MemoryListItem(memory: memory)
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete(perform: deleteMemories)
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
            .navigationTitle(memories.isEmpty ? "" : "Memories")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Memory", systemImage: Icon.addMemory) {
                        isEditorOpen = true
                    }
                }
            }
            .fullScreenCover(isPresented: $isEditorOpen) {
                MemoryEditorView(
                    onCancel: {
                        isEditorOpen = false
                    },
                    onSave: { memory in
                        isEditorOpen = false
                        modelContext.insert(memory)
                    }
                )
            }
            .fullScreenCover(item: $selectedMemory) { memory in
                MemoryPreviewView(memory: memory) {
                    selectedMemory = nil
                }
            }
        }
    }
    
    private func deleteMemories(_ indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(memories[index])
        }
    }
}

#Preview {
    MemoriesListView()
        .modelContainer(for: [Memory.self, Friend.self], inMemory: true)
}
