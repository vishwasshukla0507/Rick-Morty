//
//  View+Extension.swift
//  Rick & Morty
//
//  Created by Vishwas Shukla on 21/09/26.
//

import SwiftUI

extension View {
    func alertPopUp(viewModel: CharactersListViewModel,
                    shouldRetry: Bool,
                    action: @escaping () -> Void) -> some View {
        modifier(CustomAlertPopup(viewModel: viewModel,
                                 shouldRetry: shouldRetry,
                                 action: action))
    }
}

struct CustomAlertPopup: ViewModifier {
    @ObservedObject var viewModel: CharactersListViewModel
    let shouldRetry: Bool
    let action: () -> Void
    
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
                    if shouldRetry {
                        Button("Retry") {
                            action()
                        }
                    } else {
                        Button("Ok", role: .close) {}
                    }
                }
            } message: { error in
                Text(error.localizedDescription)
            }
    }
}
