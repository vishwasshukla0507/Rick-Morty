//
//  CharactersListView.swift
//  Rick & Morty
//
//  Created by Vishwas Shukla on 14/09/26.
//

import SwiftUI

struct CharactersListView: View {
    @StateObject var viewModel: CharactersListViewModel = .init()
    @State var searchCharacter: String = .empty
    @State private var searchTask: Task<Void, Never>?
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
        .onChange(of: searchCharacter) { _, newValue in
            searchTask?.cancel()
            searchTask = Task {
                guard !searchCharacter.isEmpty else {
                    viewModel.searchedCharacters = .init(results: [])
                    return
                }
                
                do {
                    // To wait if the user is typing something else
                    try await Task.sleep(for: .seconds(0.5))
                    guard !Task.isCancelled else { return }
                    await viewModel.getCharactersByName(name: searchCharacter)
                } catch {
                    print("No character is found")
                }
            }
        }
        .task {
            guard !charactersLoaded else { return }
            await viewModel.getAllCharacters()
            charactersLoaded = true
        }
        .alertPopUp(viewModel: viewModel)
    }
}

@ViewBuilder
func characterList(characters: [CharacterDetails]) -> some View {
    LazyVStack {
        ForEach(characters, id: \.name) { character in
            CharactersListContent(character: character)
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
