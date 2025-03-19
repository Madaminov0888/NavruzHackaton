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
    let authId: String?
    let phoneNumber: String?
    let email: String?
    let photoUrl: String?
    let dateCreated: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case authId = "auth_id"
        case phoneNumber = "phone_number"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
    }
    
    // Firebase Auth User initializer
    init(user: User) {
        self.id = user.uid
        self.authId = user.uid
        self.name = user.displayName
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.dateCreated = nil    // Set this if you have a way to get the creation date
        self.phoneNumber = user.phoneNumber
    }
    
    // Standard initializer
    init(id: String, name: String?, userName: String?, authId: String?, phoneNumber: String?, email: String?, photoUrl: String?, dateCreated: String?, isPremium: Bool) {
        self.id = id
        self.name = name
        self.authId = authId
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.phoneNumber = phoneNumber
    }
}

