//
//  CharacterDetailsView.swift
//  Rick & Morty
//
//  Created by Vishwas Shukla on 16/09/26.
//

import Kingfisher
import SwiftUI

struct CharacterDetailsView: View {
    var character: CharacterDetails?
    var body: some View {
        VStack {
            Text(character?.name ?? .empty)
                .font(.title)
                .bold()
                .foregroundStyle(.black)
            characterImage(url: URL(string: character?.thumbnail ?? .empty))
                .padding(.bottom, 8)
            characterDetails(character: character)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.cyan.opacity(0.2))
    }
}

@ViewBuilder
func characterImage(url: URL?) -> some View {
    KFImage(url)
        .placeholder {
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 200, height: 200)
                .foregroundStyle(Color.gray.opacity(0.6))
        }
        .resizable()
        .scaledToFit()
        .frame(width: 200, height: 200)
        .clipShape(Circle())
        .padding()
}

@ViewBuilder
func characterDetails(character: CharacterDetails?) -> some View {
    VStack(alignment: .leading, spacing: 10) {
        Text("Status: \(character?.status ?? .empty)")
        Text ("Species: \(character?.species ?? .empty)")
        Text("Gender: \(character?.gender ?? .empty)")
        Text("Current Location: \(character?.location.name ?? .empty)")
    }
    .font(.headline)
    .foregroundStyle(Color.black)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .padding()
    .background(Color.gray.opacity(0.2))
}

#Preview {
    CharacterDetailsView()
}
