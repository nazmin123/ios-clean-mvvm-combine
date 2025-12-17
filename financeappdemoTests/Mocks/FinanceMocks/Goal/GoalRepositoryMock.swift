//
//  GoalRepositoryMock.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 17/12/25.
//


import Combine
import Foundation
@testable import financeappdemo

final class GoalRepositoryMock: GoalRepository {
    
    var goals: [GoalEntity1] = []
    var fetchCalled = false
    
    func fetchGoals() -> AnyPublisher<[GoalEntity1], any Error> {
        fetchCalled = true
        return Just(goals)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func addOrUpdateGoal(_ goal: GoalEntity1) -> AnyPublisher<Void, any Error> {
        goals.append(goal)
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func deleteGoal(id: UUID) -> AnyPublisher<Void, any Error> {
        goals.removeAll { $0.id == id }
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
}
