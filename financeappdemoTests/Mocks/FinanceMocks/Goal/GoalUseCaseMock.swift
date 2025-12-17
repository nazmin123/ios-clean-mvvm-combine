//
//  GoalUseCaseMock.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 17/12/25.
//

import Combine
import Foundation
@testable import financeappdemo

final class GetGoalUseCaseMock: GetGoalsUseCase {
    var result: [GoalEntity1] = []
    var shouldFail = false
    var error: Error = NSError(domain: "GetGoalsUseCaseMock", code: 1)
    
    func execute() -> AnyPublisher<[GoalEntity1], Error> {
        if shouldFail {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class AddOrUpdateGoalUseCaseMock: AddOrUpdateGoalUseCase {
    var executeCalled = false
    
    func execute(_ i: GoalEntity1) -> AnyPublisher<Void, Error> {
        executeCalled = true
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class DeleteGoalUseCaseMock: DeleteGoalUseCase {
    var deletedId: UUID?
    
    func execute(id: UUID) -> AnyPublisher<Void, Error> {
        deletedId = id
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
