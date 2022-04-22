//
//  GitHubSearchEngine.swift
//  GithubGraphQL
//
//  Created by Ky Leggiero on 4/22/22.
//

import Combine
import Foundation

import Apollo
import ApolloSQLite



enum GitHubSearchEngine {
    // Empty on-purpose; all members are static
}



// MARK: - Search function

extension GitHubSearchEngine {
    static func search(for query: String, newPageStartCursor: Cursor? = nil) -> ResultsPublisher {
        
        let publisher = CurrentValueSubject<SearchProgress, Never>(.notStarted)
        
        ApolloClient.gitHubSearch.searchRepositories(
            mentioning: query,
            filter: newPageStartCursor.map { .after($0) })
        { response in
            switch response {
            case let .failure(error):
                publisher.send(.failed(cause: error))
                publisher.send(completion: .finished)
                
            case let .success(results):
                publisher.send(.complete(allResults: results))
                publisher.send(completion: .finished)
                
//                let pageInfo = results.pageInfo
//                print("pageInfo: \n")
//                print("hasNextPage: \(pageInfo.hasNextPage)")
//                print("hasPreviousPage: \(pageInfo.hasPreviousPage)")
//                print("startCursor: \(pageInfo.startCursor ?? "none")")
//                print("endCursor: \(pageInfo.endCursor ?? "none")")
//                print("\n")
//                
//                results.repos.forEach { repository in
//                    print("Name: \(repository.name)")
//                    print("Path: \(repository.url)")
//                    print("Owner: \(repository.owner.login)")
//                    print("avatar: \(repository.owner.avatarUrl)")
//                    print("Stars: \(repository.stargazers.totalCount)")
//                    print("\n")
//                }
            }
        }
        
        publisher.send(.searching())
        
        return publisher.eraseToAnyPublisher()
    }
    
    
    static func continueSearch(for query: String, appendingTo previousResults: Results) -> ResultsPublisher {
        
        guard let cursor = previousResults.pageInfo.endCursor.map({ Cursor(rawValue: $0) }) else {
            return Just(.complete(allResults: previousResults))
                .eraseToAnyPublisher()
        }
        
        return search(for: query, newPageStartCursor: cursor)
            .map { searchProgress -> SearchProgress in
                switch searchProgress {
                case .notStarted,
                        .searching(previousResults: _):
                    return .searching(previousResults: previousResults)
                    
                case .complete(allResults: let newResults):
                    return .complete(allResults: .init(
                        pageInfo: newResults.pageInfo,
                        repos: previousResults.repos + newResults.repos
                    ))
                    
                case .failed(cause: _):
                    return searchProgress
                }
            }
            .eraseToAnyPublisher()
    }
    
    
    
    typealias Results = RepositorySearchResult
    
    
    
    enum SearchProgress {
        case notStarted
        case searching(previousResults: Results? = nil)
        case complete(allResults: Results)
        case failed(cause: Error)
    }
    
    
    
    typealias ResultsPublisher = AnyPublisher<SearchProgress, Never>
}



extension GitHubSearchEngine.ResultsPublisher {
    static let notStarted = Just(Output.notStarted)
        .eraseToAnyPublisher()
}



// MARK: - Constants

private extension ApolloStore {
    static let gitHubCacheLocal = ApolloStore(cache: .local(subfolder: "github.cache"))
}

extension ApolloClient {
    static let gitHubSearch = ApolloClient(
        networkTransport: RequestChainNetworkTransport(
            interceptorProvider: DefaultInterceptorProvider(store: .gitHubCacheLocal),
            endpointURL: URL(string: "https://api.github.com/graphql")!,
            additionalHeaders: ["Authorization": "Bearer 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"]
        ),
        store: .gitHubCacheLocal
    )
}
