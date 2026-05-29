//
//  SettingsView.swift
//  Memoir
//
//  Created by Pavel Ermakov on 27.05.26.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @Environment(AuthStore.self) private var authStore
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if let user = authStore.user {
                        HStack(spacing: 14) {
                            Circle()
                                .fill(Color.memoirGold.opacity(0.15))
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Text((user.email?.prefix(1) ?? "?").uppercased())
                                        .font(.system(.title3, design: .serif).weight(.medium))
                                        .foregroundStyle(Color.memoirGold)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                if let displayName = user.displayName, !displayName.isEmpty {
                                    Text(displayName)
                                        .font(.system(.body, design: .serif).weight(.medium))
                                        .foregroundStyle(Color.memoirInk)
                                }
                                
                                if let email = user.email {
                                    Text(email)
                                        .font(.system(.subheadline, design: .serif))
                                        .foregroundStyle(Color.memoirInk.opacity(0.6))
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        signOut()
                    } label: {
                        HStack {
                            Spacer()
                            Text("signOut")
                                .font(.system(.body, design: .serif).weight(.medium))
                            Spacer()
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.memoirPaper)
            .navigationTitle(String(localized: "settings"))
            .navigationBarTitleDisplayMode(.inline)
            .alert(String(localized: "error"), isPresented: .constant(errorMessage != nil)) {
                Button("OK") { errorMessage = nil }
            } message: {
                if let errorMessage {
                    Text(errorMessage)
                }
            }
        }
    }
    
    private func signOut() {
        do {
            try authStore.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    SettingsView()
        .environment(AuthStore())
}
