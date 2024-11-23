//
//  SettingsViewModel.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/23.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {

    func resetPassowrd() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.badURL)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func updatePassword(password: String) async throws {
        let password = "password123"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    func emailVerification() async throws {
        try await AuthenticationManager.shared.emailVerification()
    }
    
}
