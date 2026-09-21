//
//  CharactersModel.swift
//  Rick & Morty
//
//  Created by Vishwas Shukla on 14/09/26.
//

struct CharactersModel: Decodable {
    let name: String
    let thumbnail: String
    let numberOfEpisodes: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case thumbnail = "image"
        case numberOfEpisodes = "episode"
    }
}
