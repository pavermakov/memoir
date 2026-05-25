//
//  AddFriendSheet.swift
//  Memoir
//
//  Created by Pavel Ermakov on 25.05.26.
//

import SwiftUI
import PhotosUI
import SwiftData

struct AddFriendSheet: View {
    @Binding var isPresented: Bool
    @Environment(\.modelContext) private var modelContext
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var profileImage: Image?
    @State private var profileImageData: Data?
    
    private var isValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    if let profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(.circle)
                    } else {
                        Circle()
                            .fill(Color.memoirGold.opacity(0.15))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: Icon.camera)
                                    .font(.system(size: 24))
                                    .foregroundStyle(Color.memoirGold)
                            )
                    }
                }
                .onChange(of: selectedItem) { _, newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self) {
                            profileImageData = data
                            if let uiImage = UIImage(data: data) {
                                profileImage = Image(uiImage: uiImage)
                            }
                        }
                    }
                }
                
                VStack(spacing: 12) {
                    TextField("First name", text: $firstName)
                        .font(.system(.body, design: .serif))
                        .foregroundStyle(Color.memoirInk)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.memoirInk.opacity(0.03))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.memoirInk.opacity(0.12), lineWidth: 1)
                        )
                    
                    TextField("Last name", text: $lastName)
                        .font(.system(.body, design: .serif))
                        .foregroundStyle(Color.memoirInk)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.memoirInk.opacity(0.03))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.memoirInk.opacity(0.12), lineWidth: 1)
                        )
                }
                
                Spacer()
            }
            .padding(24)
            .background(Color.memoirPaper)
            .navigationTitle("New Friend")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        let friend = Friend(
                            firstName: firstName.trimmingCharacters(in: .whitespaces),
                            lastName: lastName.trimmingCharacters(in: .whitespaces),
                            profileImageData: profileImageData
                        )
                        modelContext.insert(friend)
                        isPresented = false
                    }
                    .bold()
                    .foregroundStyle(Color.memoirGold)
                    .disabled(!isValid)
                }
            }
            .tint(Color.memoirGold)
        }
    }
}

#Preview {
    AddFriendSheet(isPresented: .constant(true))
        .modelContainer(for: Friend.self, inMemory: true)
}
