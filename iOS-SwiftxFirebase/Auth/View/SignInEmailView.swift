//
//  SignInEmailView.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/23.
//

import SwiftUI

struct SignInEmailView: View {
    @StateObject private var viewModel: SignInEmailViewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        VStack{
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            // next section could also be 2 buttons or using each of them depending on the view
            Button {
                Task {
                    do {
                        // Try to sign up first
                        try await viewModel.signUp()
                        showSignInView = false
                    } catch {
                        // If sign up fails, try to sign in
                        do {
                            try await viewModel.signIn()
                            showSignInView = false
                        } catch {
                            // Handle sign-in errors
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

        }
        .padding()
        .navigationTitle("Sign In with Email")
    }
}

#Preview {
    NavigationStack{
        SignInEmailView(showSignInView: .constant(false))
    }
}
