//
//  PostRepositoryImplTests.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 14/12/25.
//

import XCTest
import Combine
@testable import financeappdemo

final class PostRepositoryImplTests: XCTestCase {
    
    private var repository: PostRepositoryImpl!
    private var apiService: APIServiceMock!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        apiService = APIServiceMock()
        repository = PostRepositoryImpl(api: apiService)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        repository = nil
        apiService = nil
    }
    
    func test_fetchPosts_returnsPosts() {
        let expectation = expectation(description: "Posts fetched")
        
        let posts = [
            Post.makeMock(id: 1),
            Post.makeMock(id: 2)
        ]
        
        let data = try! JSONEncoder().encode(posts)
        apiService.result = Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        repository.fetchPosts()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { result in
                XCTAssertEqual(result.count, 2)
                XCTAssertEqual(result.first?.id, 1)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func test_fetchPosts_propagatesError() {
        let expectation = expectation(description: "Error propagated")
        
        apiService.result = Fail(error: URLError(.badServerResponse))
            .eraseToAnyPublisher()
        
        repository.fetchPosts()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Should not receive value")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
}
