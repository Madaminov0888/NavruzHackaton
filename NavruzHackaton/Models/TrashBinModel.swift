//
//  TrashBinModel.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 18/03/25.
//


import SwiftUI


struct BinCategory: Codable, Identifiable {
    let id: String
    let name: String
    let dateCreated: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case dateCreated = "date_created"
    }
    
    var randomColor: Color {
        let colors: [Color] = [
            .red, .green, .blue, .orange, .pink, .purple,
            .yellow, .gray, .teal, .mint, .indigo, .brown,
        ]
        let index = abs(id.hashValue) % colors.count
        return colors[index]
    }
    
    static func ==(lhs: BinCategory, rhs: BinCategory?) -> Bool {
        if let rhs = rhs {
            return lhs.id == rhs.id
        }
        return false
    }
}


struct TrashBin: Codable, Identifiable {
    let id: String
    let address: String?
    let locationX: Int?
    let locationY: Int?
    let categories: [BinCategory]?
    let addedBy: UserModel?
    let images: [ImageModel]?
    let dateCreated: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case address = "address"
        case locationX = "location_x"
        case locationY = "location_y"
        case categories = "categories"
        case addedBy = "added_by"
        case images = "images"
        case dateCreated = "date_created"
    }
}

