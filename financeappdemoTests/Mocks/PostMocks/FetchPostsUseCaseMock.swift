//
//  FetchPostsUseCaseMock.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 14/12/25.
//

import Combine
import Foundation
@testable import financeappdemo

final class FetchPostsUseCaseMock: FetchPostsUseCaseProtocol {
    
    var result: AnyPublisher<[Post], Error>?
    var executeCalled = false
    
    func execute() -> AnyPublisher<[Post], Error> {
        executeCalled = true
        return result ??
        Fail(error: URLError(.unknown))
            .eraseToAnyPublisher()
    }
}
