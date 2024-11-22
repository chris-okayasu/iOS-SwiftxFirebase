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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
   
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp
            .configure()
        print("Firebase is Ready!!!")

    return true
  }
}
