//
//  AuthenticationManager.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/23.
//

import Foundation
import FirebaseAuth

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private init (){}
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {

        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
        
    }
    
    // locally sdk (NOT async)
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
            
        }
        
        return AuthDataResultModel(user: user)
        
        
    }
    
}
