//
//  SignInEmailViewModel.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/25.
//

import Foundation

@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        // We do not want to create a new accout for user that already exist, just sign in
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}
