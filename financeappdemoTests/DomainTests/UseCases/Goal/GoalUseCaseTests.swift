//
//  GoalUseCaseTests.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 17/12/25.
//

import XCTest
import Combine
@testable import financeappdemo

final class GoalUseCaseTests: XCTestCase {
    
    // MUST be a property (not local)
    private var cancellables: Set<AnyCancellable>!
    private var repo: GoalRepositoryMock!
    private var useCase: GetGoalsUseCaseImpl!
    private var addUseCase: AddOrUpdateGoalUseCaseImpl!
    private var deleteUseCase: DeleteGoalUseCaseImpl!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        repo = GoalRepositoryMock()
        useCase = GetGoalsUseCaseImpl(repo: repo)
        addUseCase = AddOrUpdateGoalUseCaseImpl(repo: repo)
        deleteUseCase = DeleteGoalUseCaseImpl(repo: repo)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        cancellables = nil
        repo = nil
        useCase = nil
        addUseCase = nil
        deleteUseCase = nil
        super.tearDown()
    }
    deinit { print("GoalUseCaseTests deinit") }
    
    func testGetGoal_success() {
        let goal = GoalEntity1(
            id: UUID(),
            title: "Saving",
            targetAmount: 500,
            currentAmount: 200
            
        )
        repo.goals = [goal]
        
        let exp = expectation(description: "fetch goals")
        
        useCase.execute()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail("Unexpected error \(error)")
                    }
                },
                receiveValue: { goals in
                    XCTAssertEqual(goals, [goal])
                    exp.fulfill()
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func testAddGoal_success() {
        let goal = GoalEntity1(
            id: UUID(),
            title: "Saving",
            targetAmount: 500,
            currentAmount: 200
            
        )
        
        let exp = expectation(description: "add goal")
        
        addUseCase.execute(goal)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail("Unexpected error \(error)")
                    }
                },
                receiveValue: {
                    XCTAssertEqual(self.repo.goals.count, 1)
                    XCTAssertEqual(self.repo.goals.first, goal)
                    exp.fulfill()
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    func testDeleteGoal_success() {
        let goal = GoalEntity1(
            id: UUID(),
            title: "Saving",
            targetAmount: 500,
            currentAmount: 200
            
        )
        
        // GIVEN existing goal
        
        repo.goals = [goal]
        
        let exp = expectation(description: "delete goal")
        
        deleteUseCase.execute(id: goal.id)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail("Unexpected error \(error)")
                    }
                },
                receiveValue: {
                    XCTAssertTrue(self.repo.goals.isEmpty)
                    exp.fulfill()
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
}
