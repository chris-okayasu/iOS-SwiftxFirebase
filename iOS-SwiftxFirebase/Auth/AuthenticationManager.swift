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
    
    private init (){}
    
    // Locally SDK (NOT async)
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw AuthenticationError.userNotFound        }
        return AuthDataResultModel(
            uid: user.uid,
            email: user.email,
            photoUrl: user.photoURL?.absoluteString
        )
    }
    
    func signOut() throws {
        try Auth
            .auth()
            .signOut()
    }
}

// MARK: SIGN IN EMAIL
extension AuthenticationManager {
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
}

// MARK: SIGN IN SSO
extension AuthenticationManager {
    
    @discardableResult
    func SignInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await SignInWith(credential: credential)
    }
    
    func SignInWith(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await  Auth.auth().signIn(with: credential)
        return AuthDataResultModel(
            uid: authDataResult.user.uid,
            email: authDataResult.user.email,
            photoUrl: authDataResult.user.photoURL?.absoluteString
        )
    }
}
