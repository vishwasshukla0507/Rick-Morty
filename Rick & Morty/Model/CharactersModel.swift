//
//  CharactersModel.swift
//  Rick & Morty
//
//  Created by Vishwas Shukla on 14/09/26.
//

struct CharactersModel: Decodable {
    let results: [CharacterDetails]
}

struct CharacterDetails: Decodable {
    let name: String
    let thumbnail: String
    let numberOfEpisodes: [String]
    let status: String
    let species: String
    let gender: String
    let location: Location
    
    enum CodingKeys: String, CodingKey {
        case name
        case thumbnail = "image"
        case numberOfEpisodes = "episode"
        case status
        case species
        case gender
        case location
    }
}

struct Location: Decodable {
    let name: String
}
