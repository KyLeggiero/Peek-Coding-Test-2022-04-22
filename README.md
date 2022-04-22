# Peek iOS Coding Challenge

<img src="https://cdn.worldvectorlogo.com/logos/graphql.svg" width="200" height="200" /><img src="https://d2z5w7rcu7bmie.cloudfront.net/assets/images/logo.png" width="200" height="200" />

## Goal

Build a universial iOS app that queries GitHub for repositories that mention the phrase `GraphQL`.

The code necessary to communicate with and parse the results from GitHub have been provided for you.

Your responsibility is to showcase your ability to build a great UI/UX for interacting with the data provided in ~4 hours.

Please explain in a README file the choices you made to complete the code challenge and list the things you would have added if you had more time to spend on it.

## Setup

Fork this project and clone it to your local machine.

Dependencies are managed with [Swift Package Manager](https://developer.apple.com/documentation/swift_packages). After opening Xcode, you should see it resolving dependencies.

You will need a [Personal Access Token for GitHub](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) to run the project. Update the variable `kGitHubBearerToken` in the **Networking/ApolloClient.swift**.

### Dependencies
You are allowed to use 3rd party libraries as dependencies, but you should explain somewhere what problem(s) they solve and why you selected the specific library you did.

Any new dependencies should also be managed by SwiftPM.

Use your best judgement, as the point of this project is to showcase YOUR abilities.

## Explicit Requirements

The following are **hard** requirements. Every requirement is expected to be completed with your submission.

1. Initial launch: fetch the initial set of repos that contain the string `graphql`
1. Display the result of each repository returned from the query
1. Infinite scrolling - when reaching the bottom of the currently loaded dataset, the query should continue from the last point
1. Error handling - let the user know when an error happens
1. MVVM architecture

There are **NO** explicit requirements to use **Combine**, async/await, **RxSwift**, **SwiftUI**, **UIKit** or any other particular framework or library. It is up to you to use what you feel showcases your strengths the best.

If you have time, go above and beyond to show us your skills further by adding unit tests or new features.

## What's Provided
This project has already provided the networking code that uses the [Apollo iOS client](https://github.com/apollographql/apollo-ios) to fetch data from the GitHub GraphQL API.

There are two conformances to the `GraphQLClient` protocol: `ApolloClient` and `MockGraphQLClient`.

`ApolloClient` is the type provided by **Apollo-iOS** and is to be used at runtime. There is the static `shared` extension for getting a ready-made instance.

`MockGraphQLClient` is a client for returning mocked data in unit tests.

All `GraphQLClient` conformances have the following method for searching repositories:

```swift
@discardableResult
func searchRepositories(
  mentioning phrase: String,
  filter: SearchRepositoriesQuery.Filter? = nil,
  cachePolicy: CachePolicy = .returnCacheDataAndFetch,
  contextIdentifier: UUID? = nil,
  queue: DispatchQueue = .main,
  resultHandler: @escaping (Result<RepositorySearchResult, Error>) -> Void
) -> Cancellable {

// example of basic usage
self.client.searchRepositories(mentioning: phrase) { response in
  switch result {
  case let .success(results): print(results)
  case let .failure(error): print(error)
}
```

> Note: By default this completion handler needs to be [re-entrant safe](https://en.wikipedia.org/wiki/Reentrancy_(computing)) - it can be invoked 1-2 times for the same query as it will first return cache data (if available) and the server's response.

This method itentionally uses a completion handler in order to give you freedom to handle asynchronous programming however you see fit - async/await, **Combine**, **RxSwift**, or other **UIKit** patterns.

### Testing Helpers

There are a few testing helpers to get started with writing unit tests.

To create individual node results, use the `SearchQueryNode.makeRepository(name:owner:stargazersCount:)` factory method.

If you need to create a bunch of edge nodes - use the free function `makeEdges(count:_:)`.

In your unit tests, you can instantiate a `MockGraphQLClient` and pass it to the `ViewModel` as such:

```swift
let mockedResponse: SearchRepositoriesQuery.Data = // ...
let viewModel = ViewModel(client: MockGraphQLClient<SearchRepositoriesQuery>(response: mockedResponse))
```
