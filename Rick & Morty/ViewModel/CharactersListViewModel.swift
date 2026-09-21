//
//  CharactersListViewModel.swift
//  Rick & Morty
//
//  Created by Vishwas Shukla on 14/09/26.
//

import Foundation
import Combine

class CharactersListViewModel: ObservableObject {
    @Published var characters: CharactersModel
    @Published var searchedCharacters: CharactersModel
    @Published var isLoading: Bool = true
    @Published var apiError: APIError?
    let networkManager: NetworkManager
    
    init(characters: CharactersModel = .init(results: []),
         searchedCharacters: CharactersModel = .init(results: []),
         networkManager: NetworkManager = NetworkManager.shared) {
        self.characters = characters
        self.searchedCharacters = searchedCharacters
        self.networkManager = networkManager
    }
    
    func getUsers() async {
        do {
            characters = try await networkManager.fetch(endpoint: .characters)
            print("Fetched \(characters.results.count) characters")
        } catch {
            handleError(error: error)
        }
        
        isLoading = false
    }
    
    func getCharactersByName(name: String) async {
        do {
            searchedCharacters = try await networkManager.fetch(endpoint: .characterByName(name: name))
            print("Fetched \(characters.results.count) characters")
        } catch {
            print("Error: \(error)")
            handleError(error: error)
        }
    }
    
    func handleError(error: Error) {
        print("Handling error with description: \(error.localizedDescription)")
        switch error as? APIError {
        case .noInternet:
            apiError = .noInternet
        case .invalidResponse:
            apiError = .invalidResponse
        case .decodingFailed:
            apiError = .decodingFailed(error)
        case .invalidURL:
            apiError = .invalidURL
        default:
            apiError = .invalidResponse
        }
    }
}
