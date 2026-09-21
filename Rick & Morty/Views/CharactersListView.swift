//
//  HomeView.swift
//  Rick & Morty
//
//  Created by Vishwas Shukla on 14/09/26.
//

import SwiftUI

struct CharactersListView: View {
    @StateObject var viewModel: CharactersListViewModel = .init()
    @State var searchCharacter: String = .empty
    @State var charactersLoaded = false
    
    var body: some View {
        ScrollView {
            characterList(characters: viewModel.characters.results)
        }
        .navigationTitle("Rick & Morty")
        .navigationBarTitleDisplayMode(.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .searchable(text: $searchCharacter, placement: .navigationBarDrawer, prompt: "Search Character")
        .scrollIndicators(.hidden)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .overlay(alignment: .top) {
            if !viewModel.searchedCharacters.results.isEmpty {
                searchListView(characters: viewModel.searchedCharacters.results)
            }
        }
        .task(id: searchCharacter) {
            print("Searched Character is: \(searchCharacter)")
            guard !searchCharacter.isEmpty else {
                viewModel.searchedCharacters = .init(results: [])
                return
            }
            
            do {
                // To wait if the user is typing something else
                try await Task.sleep(for: .seconds(0.5))
                await viewModel.getCharactersByName(name: searchCharacter)
            } catch {
                print("No name is found")
            }
        }
        .task {
            guard !charactersLoaded else { return }
            await viewModel.getUsers()
            charactersLoaded = true
        }
    }
}

@ViewBuilder
func characterList(characters: [CharacterDetails]) -> some View {
    LazyVStack {
        ForEach(characters, id: \.name) { character in
            HomeViewContent(character: character)
        }
    }
}

@ViewBuilder
func searchListView(characters: [CharacterDetails]) -> some View {
    List(characters, id: \.name) { character in
        NavigationLink {
            CharacterDetailsView(character: character)
        } label: {
            Text(character.name)
        }
    }
    .listStyle(.plain)
}

#Preview {
    CharactersListView()
}
