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
            if !query.isEmpty,
               let currentResults = currentResults {
                SearchResultsView(results: currentResults) {
                    continueSearch(previousResults: currentResults)
                }
            }
            else {
                switch phase {
                case .searching:
                    Text("Searching for \(query)")
                        .onAppear {
                            print("ℹ️", query, currentResults?.repos.count ?? -1)
                        }
                    
                case .idle:
                    Text("Type a search in the text field")
                        .bold()
                        .foregroundColor(.secondary)
                }
            }
        }
        .searchable(text: $query)
        .navigationTitle("GitHub Search")
        
        
        .onChange(of: query) { newQuery in
            if query.isEmpty {
                currentResults = nil
            }
            else {
                newSearch()
            }
        }
        
        
        .onReceive(searchPublisher) { result in
            switch result {
            case .notStarted:
                phase = .idle
                
            case .searching:
                phase = .searching
                
            case .complete(allResults: let results):
                currentResults = results
                phase = .idle
                
            case .failed(cause: let cause):
                currentResults = nil
                phase = .idle
                print(cause)
                // TODO: Display error
            }
        }
        
        
        .onAppear {
            query = "graphql"
        }
    }
}



private extension GitHubSearchView {
    func newSearch() {
        searchPublisher = GitHubSearchEngine.search(for: query)
    }
    
    
    func continueSearch(previousResults: GitHubSearchEngine.Results) {
        searchPublisher = GitHubSearchEngine.continueSearch(for: query, appendingTo: previousResults)
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
