//
//  iOS_SwiftxFirebaseApp.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/22.
//

import SwiftUI
import Firebase
@main
struct iOS_SwiftxFirebaseApp: App {
    init(){
        FirebaseApp.configure()
        print("Firebase is Ready!!!")
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
