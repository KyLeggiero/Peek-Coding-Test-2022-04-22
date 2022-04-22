# Ky's approaach 2022-04-22 #

This document contains notes regarding [Ky]'s approach to this coding test as of 2022-04-22



## Initial modifications to the project ##

I converted it to a SwiftUI project because that's how I work, and there was no real established UIKit architecture so it was a trivial change.

I also inlined the two konstants since they're only ever used once in one file.

I moved search-related code to a new search engine file since they're all specifically realted to that task. Because of that, I renamed `ApolloClient.swift` to `Apollo conveniences.swift` since the old name no longer applied. The new search engine uses a Combine publisher instead of a callback.

I removed the view model since SwiftUI `View`s _are_ view models, and all of the previous code in the "view model" was searching, not modeling a view





[Ky]: https://KyLeggiero.me
