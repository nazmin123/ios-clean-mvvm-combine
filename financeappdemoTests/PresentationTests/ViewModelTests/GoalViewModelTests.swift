//
//  GoalViewModelTests.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 17/12/25.
//

import XCTest
import Combine
@testable import financeappdemo

final class GoalViewModelTests: XCTestCase {
    
    private var viewModel: GoalViewModel!
    private var getGoals: GetGoalUseCaseMock!
    private var addGoal: AddOrUpdateGoalUseCaseMock!
    private var deleteGoal: DeleteGoalUseCaseMock!
    
    override func setUp() {
        getGoals = GetGoalUseCaseMock()
        addGoal = AddOrUpdateGoalUseCaseMock()
        deleteGoal = DeleteGoalUseCaseMock()
        
        viewModel = GoalViewModel(
            getGoals: getGoals ,
            addOrUpdateGoal: addGoal,
            deleteGoal: deleteGoal
        )
    }
    
    // MARK: - fetch()
    
    func test_fetch_success_updatesItems() {
        // Arrange
        let goal = GoalEntity1.mock(target: 1000, current: 500)
        getGoals.result = [goal]
        
        // Act
        viewModel.fetch()
        
        // Assert
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertEqual(viewModel.items.first?.targetAmount, 1000)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_fetch_failure_setsErrorMessage() {
        // Arrange
        getGoals.shouldFail = true
        
        // Act
        viewModel.fetch()
        
        // Assert
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // MARK: - add()
    
    func test_add_callsAddGoalUseCase() {
        // Act
        viewModel.addGoal(title: "Test", target: 100, current: 50)
        
        // Assert
        XCTAssertTrue(addGoal.executeCalled)
    }
    
    // MARK: - delete()
    
    func test_delete_callsDeleteGoalUseCase() {
        // Arrange
        let id = UUID()
        
        // Act
        viewModel.delete(id: id)
        
        // Assert
        XCTAssertEqual(deleteGoal.deletedId, id)
    }
}
