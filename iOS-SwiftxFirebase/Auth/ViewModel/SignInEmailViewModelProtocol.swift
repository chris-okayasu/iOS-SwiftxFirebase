//
//  SignInEmailViewModelProtocol.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/23.
//

import Foundation

@MainActor
protocol SignInEmailViewModelProtocol: ObservableObject {
    var email: String { get set }
    var password: String { get set }
    func signUp() async throws
    func signIn() async throws
}
