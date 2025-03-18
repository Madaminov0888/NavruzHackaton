//
//  TrashBinModel.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 18/03/25.
//


import Foundation

struct TrashBin: Codable, Identifiable {
    let id: String
    let address: String?
    let locationX: Int?
    let locationY: Int?
    let binType: String?
    let addedBy: UserModel?
    let images: [ImageModel]?
    let dateCreated: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case address = "address"
        case locationX = "location_x"
        case locationY = "locaiton_y"
        case binType = "binType"
        case addedBy = "added_by"
        case images = "images"
        case dateCreated = "date_created"
    }
}

