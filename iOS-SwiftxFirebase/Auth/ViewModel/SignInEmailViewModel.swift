//
//  SignInEmailModel.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/23.
//

import Foundation

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    func validationLogic() {
        guard !email.isEmpty, !password.isEmpty else {
                print("Please enter email and password")
            return
        }
        // add more validation here if needed
        
    }
    
    func signUp() async throws {
        validationLogic()
        
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    func signIn() async throws {
        validationLogic()
        
        try await AuthenticationManager.shared.singInUser(email: email, password: password)

    }
    
}
