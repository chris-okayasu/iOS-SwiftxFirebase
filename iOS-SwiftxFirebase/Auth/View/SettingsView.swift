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
            
            emailSection
            
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
        }
        .navigationTitle("Settings")
    }
}

extension SettingsView {
    private var emailSection: some View {
        Section{
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
            
            // obviouly these 2 should be a fields and validations...
            Button("Update Email"){
                Task{
                    do {
                        try await viewModel.updateEmail(email: "chris@example.com")
                        print("Email updated!!!")
                    } catch{
                        print(error.localizedDescription)
                    }
                }
            }
            
            Button("Update Password"){
                Task{
                    do {
                        try await viewModel.updatePassword(password: "password123" )
                        print("Password updated!!!")
                    } catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }header:{
            Text("Email Functions")
        }
    }
}

#Preview {
    NavigationStack{
        SettingsView(showSignInView: .constant(false))
    }
}
