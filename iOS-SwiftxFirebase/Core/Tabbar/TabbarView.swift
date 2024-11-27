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
                // ProductsView()
//                    .background(Color("bg-main").ignoresSafeArea())
            }
            .tabItem {
                Image(systemName: "cart")
                Text("Products")
            }
            
            NavigationStack {
                // FavoriteView()
//                    .background(Color("bg-main").ignoresSafeArea())
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text("Favorites")
            }
            
            NavigationStack {
                ProfileView(showSignInView: $showSignInView)
                    .background(Color("bg-main").ignoresSafeArea())
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
        }
        .background(Color("bg-main").ignoresSafeArea()) // Aplicar el fondo aquí también
    }
}


#Preview {
    TabbarView(showSignInView: .constant(false))
}
