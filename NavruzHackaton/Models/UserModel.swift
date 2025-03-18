//
//  UserModel.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 18/03/25.
//

import Foundation
import FirebaseAuth



struct UserModel: Codable, Identifiable {
    let id: String
    let name: String?
    let userName: String?
    let authId: String?
    let phoneNumber: String?
    let email: String?
    let isAnonymous: Bool
    let photoUrl: String?
    let dateCreated: String?
    let isPremium: Bool

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case userName = "user_name"
        case authId = "auth_id"
        case phoneNumber = "phone_number"
        case email = "email"
        case isAnonymous = "is_anonymous"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "is_premium"
    }
    
    // Firebase Auth User initializer
    init(user: User) {
        self.id = user.uid
        self.authId = user.uid
        self.name = user.displayName
        self.userName = nil
        self.phoneNumber = user.phoneNumber
        self.email = user.email
        self.isAnonymous = false  // You can also use user.isAnonymous if preferred
        self.photoUrl = user.photoURL?.absoluteString
        self.dateCreated = nil    // Set this if you have a way to get the creation date
        self.isPremium = false    // Adjust based on your app logic
    }
    
    // Standard initializer
    init(id: String, name: String?, userName: String?, authId: String?, phoneNumber: String?, email: String?, isAnonymous: Bool, photoUrl: String?, dateCreated: String?, isPremium: Bool) {
        self.id = id
        self.name = name
        self.userName = userName
        self.authId = authId
        self.phoneNumber = phoneNumber
        self.email = email
        self.isAnonymous = isAnonymous
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
    }
}

