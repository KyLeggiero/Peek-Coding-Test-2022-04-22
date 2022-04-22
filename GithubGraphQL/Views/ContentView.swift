//
//  ContentView.swift
//  GithubGraphQL
//
//  Created by Ky Leggiero on 4/22/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            GitHubSearchView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
