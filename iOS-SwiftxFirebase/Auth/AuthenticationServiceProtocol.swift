//
//  AuthProtocol.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/23.
//

import Foundation

protocol AuthenticationServiceProtocol {
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel
    
    @discardableResult
    func singInUser(email: String, password: String) async throws -> AuthDataResultModel
    
    func getAuthenticatedUser() throws -> AuthDataResultModel
    
    func resetPassword(email: String) async throws
    
    func updatePassword(password: String) async throws
    
    func updateEmail(email: String) async throws
    
    func signOut() throws
}
