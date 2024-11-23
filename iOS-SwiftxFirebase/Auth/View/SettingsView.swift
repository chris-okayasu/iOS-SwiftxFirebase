//
//  SettingsView.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/23.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List{
            Button("Logout"){
                Task{
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch{
                        print(error.localizedDescription)
                    }
                }
            }
            
            Button("Reset password"){
                Task{
                    do {
                        try await viewModel.resetPassowrd()
                        print("passowrd reset!!!")
                    } catch{
                        print(error.localizedDescription)
                    }
                }
            }
            
            Button("Update Email"){
                Task{
                    do {
                        try await viewModel.emailVerification()
                        print("Email updated!!!")
                    } catch{
                        print(error.localizedDescription)
                    }
                }
            }
            
            Button("Update Password"){
                Task{
                    do {
                        try await viewModel.updatePassword(password: "password123" ) // obviouly this should be a security field and validations...
                        print("Password updated!!!")
                    } catch{
                        print(error.localizedDescription)
                    }
                }
            }
            
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack{
        SettingsView(showSignInView: .constant(false))
    }
}
