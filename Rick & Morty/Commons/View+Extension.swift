//
//  View+Extension.swift
//  Rick & Morty
//
//  Created by Vishwas Shukla on 21/09/26.
//

import SwiftUI

extension View {
    func alertPopUp(viewModel: CharactersListViewModel) -> some View {
        modifier(CustomAlertPopup(viewModel: viewModel))
    }
}

struct CustomAlertPopup: ViewModifier {
    @ObservedObject var viewModel: CharactersListViewModel
    
    func body(content: Content) -> some View {
        content
            .alert("Something went wrong",
                   isPresented: Binding(
                    get: { viewModel.apiError != nil },
                    set: { isPresented in
                        if !isPresented { viewModel.apiError = nil }
                    }
                   ),
                   presenting: viewModel.apiError
            ) { error in
                switch error {
                case .decodingFailed, .invalidResponse, .invalidURL, .characterNotFound:
                    Button("Ok", role: .close) {}
                }
            } message: { error in
                Text(error.localizedDescription)
            }
    }
}
