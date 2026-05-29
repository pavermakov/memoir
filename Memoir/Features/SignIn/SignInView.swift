//
//  SignInView.swift
//  Memoir
//
//  Created by Pavel Ermakov on 27.05.26.
//

import SwiftUI

struct SignInView: View {
    @Environment(AuthStore.self) private var authStore
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoading = false
    
    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 32) {
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Memoir")
                        .font(.system(.largeTitle, design: .serif).weight(.bold))
                        .foregroundStyle(Color.memoirInk)
                    
                    Text("signInSubtitle")
                        .font(.system(.subheadline, design: .serif))
                        .foregroundStyle(Color.memoirInk.opacity(0.5))
                }
                
                VStack(spacing: 12) {
                    TextField("email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
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
                    
                    PasswordField(prompt: "password", text: $password)
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
                
                if let errorMessage {
                    Text(errorMessage)
                        .font(.system(.caption, design: .serif))
                        .foregroundStyle(.red)
                }
                
                Button {
                    signIn()
                } label: {
                    Group {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("signIn")
                                .font(.system(.body, design: .serif).weight(.semibold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.memoirGold)
                .disabled(!isFormValid || isLoading)
                
                Spacer()
            }
            .padding(24)
            
        }
        .background(Color.memoirPaper.ignoresSafeArea())
    }
    
    private func signIn() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await authStore.signIn(email: email, password: password)
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

#Preview {
    SignInView()
        .environment(AuthStore())
}
