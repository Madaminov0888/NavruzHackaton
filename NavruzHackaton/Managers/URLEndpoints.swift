//
//  Endpoint.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 18/03/25.
//



import Foundation

enum URLEndpoints {
    case user(userID: String)
    case postUser
    case trashBins
    case categories

    var path: String {
        switch self {
        case .user(let userID):
            return "user/\(userID)"
        case .postUser:
            return "user/"
        case .trashBins:
            return "trashbins/"
        case .categories:
            return "categories/"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
            
        default:
            return nil
        }
    }

    var url: URL? {
        let baseURL = "http://127.0.0.1:8000/api/"
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems
        return components?.url
    }
}
