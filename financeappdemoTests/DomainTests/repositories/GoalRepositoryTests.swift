//
//  GoalRepositoryTests.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 17/12/25.
//

import XCTest
import Combine
@testable import financeappdemo

final class GoalRepositoryTest: XCTestCase {
    
    var repo: GoalCoreDataRepository!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        let container = TestPersistenceController.makeContainer()
        repo = GoalCoreDataRepository(container: container)
    }
    
    func test_addAndFetchGoal() {
        let exp = expectation(description: "Goal saved & fetched")
        let expense = GoalEntity1.mock(target: 500, current: 200)
        
        repo.addOrUpdateGoal(expense)
            .flatMap { self.repo.fetchGoals() }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { goal in
                XCTAssertEqual(goal.count, 1)
                XCTAssertEqual(goal.first?.targetAmount, 500)
                exp.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_deleteExpense_removesItem() {
        let exp = expectation(description: "Goal deleted")
        let goal = GoalEntity1.mock()
        
        repo.addOrUpdateGoal(goal)
            .flatMap { self.repo.deleteGoal(id: goal.id) }
            .flatMap { self.repo.fetchGoals() }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { goal in
                XCTAssertTrue(goal.isEmpty)
                exp.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
    }
}
