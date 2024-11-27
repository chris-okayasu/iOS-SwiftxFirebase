//
//  SettingView.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    @State private var showAlert = false
    
    var body: some View {
        List {
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
            if viewModel.authUser?.isAnonymous == true {
                anonymousSection
            }
            Button("Log out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }
            deleteAccountSection
        }
        .onAppear {
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
        }
        .background(Color("bg-main"))
        .navigationBarTitle("Settings")
    }
}

extension SettingsView {
    private var emailSection: some View {
        Section {
            Button("Reset password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("PASSWORD RESET!")
                    } catch {
                        print(error)
                    }
                }
            }
            Button("Update password") {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("PASSWORD UPDATED!")
                    } catch {
                        print(error)
                    }
                }
            }
            Button("Update email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("EMAIL UPDATED!")
                    } catch {
                        print(error)
                    }
                }
            }
        } header: {
            Text("Email functions")
        }
    }

    private var anonymousSection: some View {
        Section {
            // Botón de Google con estilo
            Button(action: {
                Task {
                    do {
                        try await viewModel.linkGoogleAccount()
                        print("GOOGLE LINKED!")
                    } catch {
                        print(error)
                    }
                }
            }) {
                HStack {
                    Image(systemName: "g.circle.fill") //TODO: Search real Google icon...
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Link Google Account")
                        .foregroundColor(.white)
                        .bold()
                }
                .padding()
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(10)
            }

            // Botón de Apple con estilo (logo blanco y fondo negro)
            Button(action: {
                Task {
                    do {
                        try await viewModel.linkAppleAccount()
                        print("APPLE LINKED!")
                    } catch {
                        print(error)
                    }
                }
            }) {
                HStack {
                    Image(systemName: "applelogo") // Logo blanco de Apple
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white) // Aseguramos que el logo sea blanco
                    Text("Link Apple Account")
                        .foregroundColor(.white)
                        .bold()
                }
                .padding()
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(Color.black)
                .cornerRadius(10)
            }
            
            // Botón de Email
            Button(action: {
                Task {
                    do {
                        try await viewModel.linkEmailAccount()
                        print("EMAIL LINKED!")
                    } catch {
                        print(error)
                    }
                }
            }) {
                HStack {
                    Image(systemName: "envelope.fill") // Icono de Email
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Link Email Account")
                        .foregroundColor(.white)
                        .bold()
                }
                .padding()
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
            }
        } header: {
            Text("Create account")
        }
    }

    private var deleteAccountSection: some View {
        Section {
            Button(role: .destructive) {
                showAlert = true
            } label: {
                Text("Delete account")
            }
            .alert("Are you sure?", isPresented: $showAlert) {
                Button("Delete", role: .destructive) {
                    Task {
                        do {
                            try await viewModel.deleteAccount()
                            showSignInView = true
                        } catch {
                            print(error)
                        }
                    }
                }
                Button("Cancel", role: .cancel) {
                    // just close alert
                }
            } message: {
                Text("This action is permanent and cannot be undone.")
            }
        }
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false))
}
