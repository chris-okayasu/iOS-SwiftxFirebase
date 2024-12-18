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
           ZStack {
               if !showSignInView {
                   NavigationStack{
                       ProductsView()
//                       ProfileView(showSignInView: $showSignInView)
                       
//                       TabbarView(showSignInView: $showSignInView)
                   }
               }
           }
           
           .onAppear {
               let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
               self.showSignInView = authUser == nil
           }
           .fullScreenCover(isPresented: $showSignInView) {
               NavigationStack {
                   AuthenticationView(showSignInView: $showSignInView)
               }
           }
//           .scrollContentBackground(.hidden)
//           .background(Color("bg-main"))
       }
   }
#Preview {
    ContentView()
}
