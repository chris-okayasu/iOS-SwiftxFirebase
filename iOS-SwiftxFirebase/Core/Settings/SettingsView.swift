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
            Button("Link Google Account") {
                Task {
                    do {
                        try await viewModel.linkGoogleAccount()
                        print("GOOGLE LINKED!")
                    } catch {
                        print(error)
                    }
                }
            }
            Button("Link Apple Account") {
                Task {
                    do {
                        try await viewModel.linkAppleAccount()
                        print("APPLE LINKED!")
                    } catch {
                        print(error)
                    }
                }
            }
            Button("Link Email Account") {
                Task {
                    do {
                        try await viewModel.linkEmailAccount()
                        print("EMAIL LINKED!")
                    } catch {
                        print(error)
                    }
                }
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
