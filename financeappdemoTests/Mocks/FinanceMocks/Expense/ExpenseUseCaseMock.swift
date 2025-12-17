//
//  ExpenseUseCaseMock.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 15/12/25.
//

import Combine
import Foundation
@testable import financeappdemo

final class GetExpenseUseCaseMock: GetExpensesUseCase {
    var result: [ExpenseEntity1] = []
    var shouldFail = false
    var executeCalled = false
    var error: Error = NSError(domain: "GetExpenseUseCaseMock", code: 1)
    
    func execute() -> AnyPublisher<[ExpenseEntity1], Error> {
        executeCalled = true
        if shouldFail {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class AddExpenseUseCaseMock: AddExpenseUseCase {
    var executeCalled = false
    var shouldFail = false
    
    func execute(_ i: ExpenseEntity1) -> AnyPublisher<Void, Error> {
        executeCalled = true
        if shouldFail {
            return Fail(error: NSError(domain: "test", code: -1))
                .eraseToAnyPublisher()
        }
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class DeleteExpenseUseCaseMock: DeleteExpenseUseCase {
    var deletedId: UUID?
    var shouldFail = false
    func execute(id: UUID) -> AnyPublisher<Void, Error> {
        deletedId = id
        if shouldFail {
            return Fail(error: NSError(domain: "test", code: -1))
                .eraseToAnyPublisher()
        }
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
