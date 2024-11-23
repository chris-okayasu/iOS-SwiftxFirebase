//
//  AuthenticationManager.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/23.
//

import Foundation
import FirebaseAuth

enum AuthenticationError: LocalizedError {
    case userNotFound
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "No se encontró un usuario autenticado. Por favor, inicia sesión e inténtalo de nuevo."
        case .unknownError:
            return "Ocurrió un error desconocido. Por favor, inténtalo más tarde."
        }
    }
}

final class AuthenticationManager:AuthenticationServiceProtocol {
    
    static let shared = AuthenticationManager()
    
    private init (){
    }
    
    // Login by Email and password Logic
    @discardableResult
    func createUser(
        email: String,
        password: String
    ) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(
            withEmail: email,
            password: password
        )
        return AuthDataResultModel(
            uid: authDataResult.user.uid,
            email: authDataResult.user.email,
            photoUrl: authDataResult.user.photoURL?.absoluteString
        )
        
    }
    
    @discardableResult
    func singInUser(
        email: String,
        password: String
    ) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(
            withEmail: email,
            password: password
        )
        return AuthDataResultModel(
            uid: authDataResult.user.uid,
            email: authDataResult.user.email,
            photoUrl: authDataResult.user.photoURL?.absoluteString
        )
    }
    
    // Locally SDK (NOT async)
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw AuthenticationError.userNotFound        }
        // Convertir el objeto Firebase `User` al modelo desacoplado `AuthDataResultModel`
        return AuthDataResultModel(
            uid: user.uid,
            email: user.email,
            photoUrl: user.photoURL?.absoluteString
        )
    }
    
    
    func resetPassword(
        email: String
    ) async throws {
        try await Auth
            .auth()
            .sendPasswordReset(
                withEmail: email
            )
    }
    
    func updatePassword(
        password: String
    ) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(
                .badServerResponse
            )
        }
        try await user
            .updatePassword(
                to: password
            )
        
    }
    
    func updateEmail(
        email: String
    ) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(
                .badServerResponse
            )
        }
        try await user
            .sendEmailVerification(
                beforeUpdatingEmail: email
            )
    }
    
    func signOut() throws {
        try Auth
            .auth()
            .signOut()
    }
}
