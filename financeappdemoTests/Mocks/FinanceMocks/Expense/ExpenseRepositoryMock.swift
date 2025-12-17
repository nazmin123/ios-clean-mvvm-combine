//
//  ExpenseRepositoryMock.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 17/12/25.
//

import Combine
import Foundation
@testable import financeappdemo

final class ExpenseRepositoryMock: ExpenseRepository {
    var expense: [ExpenseEntity1] = []
    var fetchCalled = false
    
    func fetchExpense() -> AnyPublisher<[ExpenseEntity1], Error> {
        fetchCalled = true
        return Just(expense)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func addExpense(_ income: ExpenseEntity1) -> AnyPublisher<Void, Error> {
        expense.append(income)
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func deleteExpense(id: UUID) -> AnyPublisher<Void, Error> {
        expense.removeAll { $0.id == id }
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
