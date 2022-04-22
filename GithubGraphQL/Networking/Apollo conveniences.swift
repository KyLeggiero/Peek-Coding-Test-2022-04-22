import Apollo
import ApolloSQLite
import Foundation



// MARK: - Helpers

extension NormalizedCache where Self == SQLiteNormalizedCache {
    static func local(subfolder: String) -> Self {
        try! .init(
            fileURL: try! FileManager.default
                .url(
                    for: .cachesDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                )
                .appendingPathComponent(subfolder)
        )
    }
}
