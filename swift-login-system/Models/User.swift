//
//  User.swift
//  swift-login-system
//
//  Created by elif uyar on 6.11.2024.
//

import Foundation
struct User{
        let username: String
        let email: String
        let userUID: String
        let profileImageUrl:String?
    
    init(username: String, email: String, userUID: String, profileImageUrl: String? = nil) {
            self.username = username
            self.email = email
            self.userUID = userUID
            self.profileImageUrl = profileImageUrl
        }
}
