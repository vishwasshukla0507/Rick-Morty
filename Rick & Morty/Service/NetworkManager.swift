//
//  ServiceManager.swift
//  Rick & Morty
//
//  Created by Vishwas Shukla on 19/09/26.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case requestFailed(statusCode: Int)
    case decodingFailed(Error)
}

class ServiceManager {
    
}
