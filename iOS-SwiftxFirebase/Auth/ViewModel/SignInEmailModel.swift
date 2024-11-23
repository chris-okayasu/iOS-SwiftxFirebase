//
//  SignInEmailModel.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/23.
//

import Foundation

@MainActor
final class SignInEmailModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    
    func signIn(){
        guard !email.isEmpty, !password.isEmpty else {
                print("Please enter email and password")
            return
        }
        //add more validation here...
        
        
        Task{
            do {
                let returndedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("Success!")
                print(returndedUserData)
            }catch {
                print("Error: \(error)")
            }
        }
        
    }
}
