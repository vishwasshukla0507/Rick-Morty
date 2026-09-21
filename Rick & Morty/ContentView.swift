//
//  ContentView.swift
//  Rick & Morty
//
//  Created by Vishwas Shukla on 14/09/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            CharactersListView()
        }
    }
}

#Preview {
    ContentView()
}
