//
//  ContentView.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/22.
//

import SwiftUI
// Root
struct ContentView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack{
            NavigationStack{
                SettingsView(showSignInView: $showSignInView)
            }
        }
        .onAppear{
            //TODO: get the user one the app runs
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView){
            NavigationStack{
                AuthView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    ContentView()
}
