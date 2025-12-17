//
//  IncomeRepositoryMock.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 16/12/25.
//
import Combine
import Foundation
@testable import financeappdemo

final class IncomeRepositoryMock: IncomeRepository {
    var incomes: [IncomeEntity1] = []
    var fetchCalled = false
    
    func fetchIncomes() -> AnyPublisher<[IncomeEntity1], Error> {
        fetchCalled = true
        return Just(incomes)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func addIncome(_ income: IncomeEntity1) -> AnyPublisher<Void, Error> {
        incomes.append(income)
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func deleteIncome(id: UUID) -> AnyPublisher<Void, Error> {
        incomes.removeAll { $0.id == id }
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
