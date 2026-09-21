//
//  APIEndPoint.swift
//  Rick & Morty
//
//  Created by Vishwas Shukla on 19/09/26.
//

import Foundation

enum APIEndPoint {
    case characters
    case characterByName(name: String)
    
    var baseURL: String {
        return Constants.baseURL
    }
    
    var path: String {
        switch self {
        case .characters, .characterByName:
            return Constants.character
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .characterByName(name: let name):
            return [URLQueryItem(name: Constants.name, value: name)]
        default:
            return nil
        }
    }
    
    var url: URL? {
        guard let base = URL(string: baseURL) else { return nil }
        let completeURL = base.appendingPathComponent(path)
        guard var components = URLComponents(url: completeURL, resolvingAgainstBaseURL: true) else { return nil }
        if let queryItems {
            components.queryItems = queryItems
        }
        return components.url
    }
}
