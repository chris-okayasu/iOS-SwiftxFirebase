//
//  SignInEmailModel.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/23.
//

import Foundation

@MainActor
final class SignInEmailViewModel: ObservableObject, SignInEmailViewModelProtocol {
    @Published var email: String = ""
        @Published var password: String = ""
        @Published var errorMessage: String? // To expose error messages to the UI
        @Published var isSignedIn: Bool = false // State to indicate if the user has signed in

        // Validation logic for email and password
        func validationLogic() {
            guard !email.isEmpty, !password.isEmpty else {
                errorMessage = "Please enter an email and password."
                return
            }
            // Add more validations as needed
        }
        
        // Sign up logic for creating a new user
    func signUp() async throws {
            validationLogic()
            guard errorMessage == nil else {
                return
            }
            
            do {
                // Try to create a user with provided email and password
                try await AuthenticationManager.shared
                    .createUser(
                        email: email,
                        password: password
                    )
                isSignedIn = true // Update state if user creation is successful
            } catch let error as AuthenticationError {
                errorMessage = error.localizedDescription // Handle custom errors
            } catch {
                errorMessage = "Unexpected error: \(error.localizedDescription)"
            }
        }
    
    // Sign-in logic for existing users
    func signIn() async throws {
        validationLogic()
        guard errorMessage == nil else {
            return
        }
        
        do {
            // Try to sign in the user with provided email and password
            let user = try await AuthenticationManager.shared.singInUser(
                email: email,
                password: password
            )
            isSignedIn = true // Update state if sign-in is successful
            print("Authenticated user: \(user.email ?? "No email")")
            } catch let error as AuthenticationError {
                errorMessage = error.localizedDescription // Handle custom errors
            } catch {
                errorMessage = "Unexpected error: \(error.localizedDescription)"
            }
        }
}
