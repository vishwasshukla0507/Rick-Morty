//
//  APIEndPoints.swift
//  Rick & Morty
//
//  Created by Vishwas Shukla on 19/09/26.
//

import Foundation

enum APIEndPoints {
    case characters
    case characterByName(name: String)
    
    var baseURL: String {
        return "https://rickandmortyapi.com/api"
    }
    
    var path: String {
        switch self {
        case .characters:
            return "character"
        case .characterByName(name: let name):
            return "character/\(name)"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .characterByName(name: let name):
            return [URLQueryItem(name: "name", value: name)]
        default:
            return nil
        }
    }
    
    var url: URL? {
        guard var components = URLComponents(string: baseURL) else { return nil }
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
