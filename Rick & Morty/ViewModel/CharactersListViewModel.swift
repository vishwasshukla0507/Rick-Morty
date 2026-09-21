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
    
    func getAllCharacters() async {
        do {
            characters = try await networkManager.fetch(endpoint: .characters)
            print("Fetched \(characters.results.count) characters")
        } catch {
            characters = .init(results: [])
            print("Error while fetching characters: \(error)")
        }
        
        isLoading = false
    }
    
    func getCharactersByName(name: String) async {
        do {
            searchedCharacters = try await networkManager.fetch(endpoint: .characterByName(name: name))
            print("Fetched \(searchedCharacters.results.count) character(s)")
        } catch {
            print("Error while searching for character: \(error)")
            searchedCharacters = .init(results: [])
            apiError = error as? APIError
            apiError = .characterNotFound
        }
    }
}
