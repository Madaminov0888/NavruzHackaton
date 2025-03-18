//
//  File.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 18/03/25.
//

import Foundation


struct ImageModel: Codable, Identifiable {
    let id: String
    let downloadUrl: String?
    let storageId: String?
    let dateCreated: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case downloadUrl = "download_url"
        case storageId = "storage_id"
        case dateCreated = "date_created"
    }
}
