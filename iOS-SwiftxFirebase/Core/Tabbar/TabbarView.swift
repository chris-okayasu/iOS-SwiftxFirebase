//
//  TabbarView.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/25.
//

import SwiftUI

struct TabbarView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            NavigationStack {
//                ProductsView()
            }
            .tabItem {
                Image(systemName: "cart")
                Text("Products")
            }
            
            NavigationStack {
//                FavoriteView()
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text("Favorites")
            }
            
            NavigationStack {
                ProfileView(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
        }
    }
}
#Preview {
    TabbarView(showSignInView: .constant(false))
}
