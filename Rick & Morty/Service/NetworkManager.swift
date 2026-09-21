//
//  NetworkManager.swift
//  Rick & Morty
//
//  Created by Vishwas Shukla on 19/09/26.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed(Error)
    case characterNotFound
    
    var errorDescription: String? {
        switch self {
        case .invalidURL, .invalidResponse, .decodingFailed:
            return "Please try again later."
        case .characterNotFound:
            return "Character not found, please try with another name"
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetch<T: Decodable>(endpoint: APIEndPoint) async throws -> T {
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            
            throw APIError.decodingFailed(error)
        }
    }
}
