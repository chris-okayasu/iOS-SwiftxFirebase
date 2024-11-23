//
//  AuthDataResultModel.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/23.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
//    init(user: User){
//        self.uid = user.uid
//        self.email = user.email
//        self.photoUrl = user.photoURL?.absoluteString
//    }
}
