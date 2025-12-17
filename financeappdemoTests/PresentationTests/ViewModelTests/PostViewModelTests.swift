//
//  PostViewModelTests.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 14/12/25.
//

import XCTest
import Combine
@testable import financeappdemo

final class PostViewModelTests: XCTestCase {
    
    private var viewModel: PostViewModel!
    private var useCase: FetchPostsUseCaseMock!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        useCase = FetchPostsUseCaseMock()
        viewModel = PostViewModel(fetchPostsUseCase: useCase)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        viewModel = nil
        useCase = nil
    }
    
    func test_loadPosts_successfullyLoadsPosts() {
        let expectation = expectation(description: "Posts loaded")
        
        let posts = [
            Post.makeMock(id: 1),
            Post.makeMock(id: 2)
        ]
        
        useCase.result = Just(posts)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        viewModel.$posts
            .dropFirst()
            .sink { result in
                XCTAssertEqual(result.count, 2)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.loadPosts()
        
        XCTAssertTrue(useCase.executeCalled)
        
        
        waitForExpectations(timeout: 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
  //  func test_loadPosts_setsErrorOnFailure() {
//        useCase.result = Fail(error: URLError(.timedOut))
//            .eraseToAnyPublisher()
//        
//        viewModel.loadPosts()
//        
//        XCTAssertNotNil(viewModel.errorMessage)
//        XCTAssertFalse(viewModel.isLoading)
//    }
//    
//    func test_loadPosts_clearsPreviousError() {
//        useCase.result = Fail(error: URLError(.badURL))
//            .eraseToAnyPublisher()
//        
//        viewModel.loadPosts()
//        XCTAssertNotNil(viewModel.errorMessage)
//        
//        useCase.result = Just([])
//            .setFailureType(to: Error.self)
//            .eraseToAnyPublisher()
//        
//        viewModel.loadPosts()
//        XCTAssertNil(viewModel.errorMessage)
//    }
    
    
}
