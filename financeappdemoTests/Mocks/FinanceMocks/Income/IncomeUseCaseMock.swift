//
//  IncomeUseCaseMock.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 14/12/25.
//
import Combine
import Foundation
@testable import financeappdemo

final class GetIncomesUseCaseMock: GetIncomesUseCase {
    var result: [IncomeEntity1] = []
    var shouldFail = false
    var error: Error = NSError(domain: "GetIncomesUseCaseMock", code: 1)
    
    func execute() -> AnyPublisher<[IncomeEntity1], Error> {
        if shouldFail {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class AddIncomeUseCaseMock: AddIncomeUseCase {
    var executeCalled = false
    
    func execute(_ i: IncomeEntity1) -> AnyPublisher<Void, Error> {
        executeCalled = true
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class DeleteIncomeUseCaseMock: DeleteIncomeUseCase {
    var deletedId: UUID?
    
    func execute(id: UUID) -> AnyPublisher<Void, Error> {
        deletedId = id
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

