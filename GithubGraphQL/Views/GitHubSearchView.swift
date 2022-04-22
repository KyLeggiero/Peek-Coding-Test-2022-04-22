//
//  GitHubSearchView.swift
//  GithubGraphQL
//
//  Created by Ky Leggiero on 4/22/22.
//  Copyright © 2022 test. All rights reserved.
//

import Combine
import SwiftUI



struct GitHubSearchView: View {
    
    @State
    private var query = ""
    
    @State
    private var phase: Phase = .idle
    
    @State
    private var currentResults: GitHubSearchEngine.Results?
    
    @State
    private var searchPublisher: GitHubSearchEngine.ResultsPublisher = .notStarted
    
    
    var body: some View {
        Group {
            switch phase {
            case .searching:
                Text("Searching for \(query)")
                
            case .idle:
                if let currentResults = currentResults {
                    Text("Found \(currentResults.repos.count)")
                }
                else {
                    Text("Type a search in the text field")
                }
            }
        }
        .searchable(text: $query)
        .navigationTitle("GitHub Search")
        
        
        .onChange(of: query) { newQuery in
            searchPublisher = GitHubSearchEngine.search(for: query)
        }
        
        .onReceive(searchPublisher) { result in
            switch result {
            case .notStarted:
                currentResults = nil
                phase = .idle
                
            case .searching:
                currentResults = nil
                phase = .searching
                
            case .complete(results: let results):
                currentResults = results
                phase = .idle
                
            case .failed(cause: let cause):
                currentResults = nil
                phase = .idle
                print(cause)
                // TODO: Display error
            }
        }
    }
}



private extension GitHubSearchView {
    /// The current state of a `GitHubSearchView`
    enum Phase {
        case searching
        case idle
    }
}




struct GitHubSearchView_Previews: PreviewProvider {
    static var previews: some View {
        GitHubSearchView()
    }
}
