//
//  ExpenseViewModelTest.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 17/12/25.
//

import XCTest
import Combine
@testable import financeappdemo

final class ExpenseViewModelTests: XCTestCase {
    
    private var viewModel: ExpenseViewModel!
    private var getExpense: GetExpenseUseCaseMock!
    private var addExpense: AddExpenseUseCaseMock!
    private var deleteExpense: DeleteExpenseUseCaseMock!
    
    override func setUp() {
        getExpense = GetExpenseUseCaseMock()
        addExpense = AddExpenseUseCaseMock()
        deleteExpense = DeleteExpenseUseCaseMock()
        
        viewModel = ExpenseViewModel(
            getExpenses : getExpense ,
            addExpense : addExpense,
            deleteExpense: deleteExpense
        )
    }
    
    // MARK: - fetch()
    
    func test_fetch_success_updatesItems() {
        // Arrange
        let expense = ExpenseEntity1.mock(amount: 500)
        getExpense.result = [expense]
        
        // Act
        viewModel.fetch()
        
        // Assert
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertEqual(viewModel.items.first?.amount, 500)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_fetch_failure_setsErrorMessage() {
        // Arrange
        getExpense.shouldFail = true
        
        // Act
        viewModel.fetch()
        
        // Assert
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // MARK: - add()
    
    func test_add_callsAddExpenseUseCase() {
        // Act
        viewModel.add(amount: 300)
        
        // Assert
        XCTAssertTrue(addExpense.executeCalled)
    }
    
    // MARK: - delete()
    
    func test_delete_callsDeleteExpenseUseCase() {
        // Arrange
        let id = UUID()
        
        // Act
        viewModel.delete(id: id)
        
        // Assert
        XCTAssertEqual(deleteExpense.deletedId, id)
    }
    
    func test_fetch_setsLoadingStateCorrectly() {
        let expense = ExpenseEntity1.mock(amount: 100)
        getExpense.result = [expense]
        
        viewModel.fetch()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.items.count, 1)
    }
    
    func test_add_triggersFetchAfterSuccess() {
        let expense = ExpenseEntity1.mock(amount: 200)
        getExpense.result = [expense]
        
        viewModel.add(amount: 200)
        
        XCTAssertTrue(addExpense.executeCalled)
        XCTAssertTrue(getExpense.executeCalled)
    }
    
    func test_delete_triggersFetchAfterSuccess() {
        let id = UUID()
        let expense = ExpenseEntity1(id: id, amount: 100, date: Date(), note: nil)
        getExpense.result = []
        
        viewModel.delete(id: id)
        
        XCTAssertEqual(deleteExpense.deletedId, id)
        XCTAssertTrue(getExpense.executeCalled)
    }
    func test_add_failure_doesNotCrash() {
        addExpense.shouldFail = true
        
        viewModel.add(amount: 100)
        
        XCTAssertTrue(addExpense.executeCalled)
    }
    
}
