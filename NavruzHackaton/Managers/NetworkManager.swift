//
//  NetworkManager.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 18/03/25.
//

import UIKit


protocol NetworkManagerProtocol {
    func fetchData<T:Codable>(for endpoint: URLEndpoints, type: T.Type) async throws -> T
    func postData<T:Codable>(for endpoint: URLEndpoints, data: T) async throws
}


final class NetworkManager: NetworkManagerProtocol {
    
    private let session: URLSession

    init(session: URLSession = .shared) {
        let config = URLSessionConfiguration.default
        self.session = URLSession(configuration: config)
    }
    
    
    func handleHttpResponse(response: URLResponse, data: Data? = nil) throws {
        guard let httpResponse = response as? HTTPURLResponse,
        httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            print("Error Raw response data: \(String(data: data ?? Data(), encoding: .utf8) ?? "Invalid data")")
            throw NetworkErrors.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
    }
    
    func fetchData<T>(for endpoint: URLEndpoints, type: T.Type) async throws -> T where T : Decodable {
        guard let url = endpoint.url else {
            throw NetworkErrors.invalidURL
        }
        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)
        try handleHttpResponse(response: response, data: data)
        let responseModel = try JSONDecoder().decode(T.self, from: data)
        return responseModel
    }
    
    
    func postData<T>(for endpoint: URLEndpoints, data: T) async throws where T : Encodable {
        guard let url = endpoint.url else {
            throw NetworkErrors.invalidURL
        }
        
        let data = try JSONEncoder().encode(data)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, resposne) = try await session.data(for: request)
        try handleHttpResponse(response: resposne)
    }
    
}



enum NetworkErrors: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingError(Error)
    case serverError(statusCode: Int)
}


extension NetworkErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The provided username is invalid. Please check the username and try again.", comment: "Message for invalid URL error")
        case .invalidResponse:
            return NSLocalizedString("The server response is invalid. Please try again later.", comment: "Message for invalid response error")
        case .invalidData:
            return NSLocalizedString("The received data is invalid or corrupted. Please try again.", comment: "Message for invalid data error")
        case .decodingError(let error):
            return NSLocalizedString("Failed to decode the data: \(error.localizedDescription). Please contact support.", comment: "Message for decoding error")
        case .serverError(let statusCode):
            return NSLocalizedString("The server returned an error with status code: \(statusCode). Please try again later.", comment: "Message for server error")
        }
    }
}
