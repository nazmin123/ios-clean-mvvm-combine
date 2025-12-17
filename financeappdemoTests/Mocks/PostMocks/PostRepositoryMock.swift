//
//  PostRepositoryMock.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 14/12/25.
//
import Combine
import Foundation
@testable import financeappdemo

final class PostRepositoryMock: PostRepository {
    
    var result: AnyPublisher<[Post], Error>?
    
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        result ??
        Fail(error: URLError(.unknown))
            .eraseToAnyPublisher()
    }
}

