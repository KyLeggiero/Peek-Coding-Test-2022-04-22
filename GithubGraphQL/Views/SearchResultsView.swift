//
//  SearchResultsView.swift
//  GithubGraphQL
//
//  Created by Ky Leggiero on 4/22/22.
//  Copyright © 2022 test. All rights reserved.
//

import SwiftUI

struct SearchResultsView: View {
    
    let results: RepositorySearchResult
    
    let onLoadMore: () -> Void
    
    
    var body: some View {
        if results.repos.isEmpty {
            Text("No results")
                .foregroundColor(.secondary)
        }
        else {
            List {
                Section {
                    ForEach(results.repos, id: \.url) { result in
                        SearchResult(result: result)
                    }
                }
                
                Section {
                    if results.pageInfo.hasNextPage {
                        Button("Loading more...", action: onLoadMore)
                            .onAppear(perform: onLoadMore)
                    }
                    else {
                        Text("That's all the results!")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
    }
}



private extension SearchResultsView {
    struct SearchResult: View {
        
        let result: RepositoryDetails
        
        var body: some View {
            Text(result.name)
        }
    }
}



struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(results: .init(pageInfo: .init(hasNextPage: false, hasPreviousPage: false),
                                         repos: []),
                          onLoadMore: {})
    }
}
