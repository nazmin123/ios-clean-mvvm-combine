////
////  IncomeViewModelTests.swift
////  financeappdemo
////
////  Created by Nazmin Parween on 14/12/25.

import XCTest
import Combine
@testable import financeappdemo

final class IncomeViewModelTests: XCTestCase {
    
    private var viewModel: IncomeViewModel!
    private var getIncomes: GetIncomesUseCaseMock!
    private var addIncome: AddIncomeUseCaseMock!
    private var deleteIncome: DeleteIncomeUseCaseMock!
    
    override func setUp() {
        getIncomes = GetIncomesUseCaseMock()
        addIncome = AddIncomeUseCaseMock()
        deleteIncome = DeleteIncomeUseCaseMock()
        
        viewModel = IncomeViewModel(
            getIncomes: getIncomes,
            addIncome: addIncome,
            deleteIncome: deleteIncome
        )
    }
    
    // MARK: - fetch()
    
    func test_fetch_success_updatesItems() {
        // Arrange
        let income = IncomeEntity1.mock(amount: 500)
        getIncomes.result = [income]
        
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
        getIncomes.shouldFail = true
        
        // Act
        viewModel.fetch()
        
        // Assert
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // MARK: - add()
    
    func test_add_callsAddIncomeUseCase() {
        // Act
        viewModel.add(amount: 300)
        
        // Assert
        XCTAssertTrue(addIncome.executeCalled)
    }
    
    // MARK: - delete()
    
    func test_delete_callsDeleteIncomeUseCase() {
        // Arrange
        let id = UUID()
        
        // Act
        viewModel.delete(id: id)
        
        // Assert
        XCTAssertEqual(deleteIncome.deletedId, id)
    }
}
