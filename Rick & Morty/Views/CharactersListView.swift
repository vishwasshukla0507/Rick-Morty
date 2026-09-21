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
                    //                    print("The error is: \(error)")
                }
            }
        }
        .task {
            guard !charactersLoaded else { return }
            await viewModel.getUsers()
            charactersLoaded = true
        }
        .customAlert(viewModel: viewModel)
        //        .errorAlert(error: $viewModel.apiError) {
        //            Task { await viewModel.getUsers() }
        //        }
    }
}

struct CustomAlertPopup: ViewModifier {
    @ObservedObject var viewModel: CharactersListViewModel
    func body(content: Content) -> some View {
        content
            .alert(viewModel.apiError.debugDescription.contains("noInternet") ? "No Internet Connection" : "Something went wrong",
                   isPresented: Binding(
                    get: { viewModel.apiError != nil },
                    set: { isPresented in
                        if !isPresented { viewModel.apiError = nil }
                    }
                   ),
                   presenting: viewModel.apiError
            ) { error in
                switch error {
                case .noInternet, .decodingFailed, .invalidResponse, .invalidURL:
                    Button("Retry") {
                        Task {
                            print("The error is: \(error)")
                            await viewModel.getUsers()
                        }
                    }
                }
            } message: { error in
                Text(error.localizedDescription)
            }
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

extension View {
    func errorAlert(error: Binding<APIError?>, retryAction: @escaping () -> Void) -> some View {
        self.alert("Error",
                   isPresented: Binding(
                    get: {
                        error.wrappedValue != nil
                    }, set: { isPresented in
                        if !isPresented { error.wrappedValue = nil }
                    }
                   ), presenting: error.wrappedValue) { _ in
                       Button("Retry") { retryAction() }
                   } message: { error in
                       Text(error.localizedDescription)
                   }
    }
    
    func customAlert(viewModel: CharactersListViewModel) -> some View {
        modifier(CustomAlertPopup(viewModel: viewModel))
    }
}
