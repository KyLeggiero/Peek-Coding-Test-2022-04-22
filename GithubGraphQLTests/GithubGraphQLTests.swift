@testable import GithubGraphQL
import Combine
import XCTest



private var testPublishers = Set<AnyCancellable>()



class GithubGraphQLTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        let mockedResponse = SearchRepositoriesQuery.Data(search: .init(
            pageInfo: .init(startCursor: "startCursor", endCursor: nil, hasNextPage: false, hasPreviousPage: false),
            edges: makeEdges(count: 3)
        ))
        
        let expectation = self.expectation(description: "Search Complete")
        
        GitHubSearchEngine.search(for: "what", client: MockGraphQLClient<SearchRepositoriesQuery>(response: mockedResponse))
            .sink { completion in
                switch completion {
                case .failure(_):
                    XCTFail("This should never fail")
                    
                case .finished:
                    expectation.fulfill()
                }
            }
            receiveValue: { progress in
                switch progress {
                case .notStarted:
                    break
                    
                case .searching(previousResults: let previousResults):
                    XCTAssertNil(previousResults)
                    
                case .complete(allResults: let allResults):
                    print(allResults)
                    break
                    
                case .failed(cause: let cause):
                    XCTFail(cause.localizedDescription)
                }
            }
            .store(in: &testPublishers)
        
        wait(for: [expectation], timeout: 5)
    }
}
