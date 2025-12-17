//
//  FetchPostsUseCaseTests.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 14/12/25.
//

import XCTest
import Combine
@testable import financeappdemo

final class FetchPostsUseCaseTests: XCTestCase {
    
    private var useCase: FetchPostsUseCase!
    private var repository: PostRepositoryMock!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        repository = PostRepositoryMock()
        useCase = FetchPostsUseCase(repository: repository)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        useCase = nil
        repository = nil
    }
    
    func test_execute_returnsPosts() {
        let expectation = expectation(description: "Posts returned")
        
        let posts = [Post.makeMock()]
        repository.result = Just(posts)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        useCase.execute()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { result in
                XCTAssertEqual(result.count, 1)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func test_execute_propagatesError() {
        let expectation = expectation(description: "Error returned")
        
        repository.result = Fail(error: URLError(.notConnectedToInternet))
            .eraseToAnyPublisher()
        
        useCase.execute()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
}
