//
//  CharactersListContent.swift
//  Rick & Morty
//
//  Created by Vishwas Shukla on 18/09/26.
//

import Kingfisher
import SwiftUI

struct CharactersListContent: View {
    var character: CharacterDetails?
    
    var body: some View {
        NavigationLink {
            CharacterDetailsView(character: character)
        } label: {
            homeViewContentNavigationLabel(for: character)
        }
        .buttonStyle(.plain)
    }
}

@ViewBuilder
func homeViewContentNavigationLabel(for character: CharacterDetails?) -> some View {
    HStack(alignment: .top, spacing: 10) {
        KFImage(URL(string: character?.thumbnail ?? .empty))
            .placeholder {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        
        VStack(alignment: .leading) {
            Text(character?.name ?? .empty)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Number of episodes: \(character?.numberOfEpisodes.count ?? .zero)")
                .font(.subheadline)
        }
        
        Spacer()
    }
    .frame(alignment: .topLeading)
    .padding(8)
    .background(Color.mint.opacity(0.2))
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .shadow(radius: 4)
    .padding(8)
}

#Preview {
    CharactersListContent()
}
