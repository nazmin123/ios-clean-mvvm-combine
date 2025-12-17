//
//  ExpenseUseCase.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 17/12/25.
//

import XCTest
import Combine
@testable import financeappdemo

final class ExpenseUseCaseTests: XCTestCase {
    
    // MUST be a property (not local)
    private var cancellables: Set<AnyCancellable>!
    private var repo: ExpenseRepositoryMock!
    private var useCase: GetExpenseUseCaseImpl!
    private var addUseCase: AddExpenseUseCaseImpl!
    private var deleteUseCase: DeleteExpenseUseCaseImpl!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        repo = ExpenseRepositoryMock()
        useCase = GetExpenseUseCaseImpl(repo: repo)
        addUseCase = AddExpenseUseCaseImpl(repo: repo)
        deleteUseCase = DeleteExpenseUseCaseImpl(repo: repo)
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
    deinit { print("ExpenseUseCaseTests deinit") }
    
    func testGetExpense_success() {
        let expense = ExpenseEntity1(
            id: UUID(),
            amount: 500,
            date: Date(),
            note: "Test"
        )
        repo.expense = [expense]
        
        let exp = expectation(description: "fetch expenses")
        
        useCase.execute()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail("Unexpected error \(error)")
                    }
                },
                receiveValue: { expenses in
                    XCTAssertEqual(expenses, [expense])
                    exp.fulfill()
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func testAddExpense_success() {
        let expense = ExpenseEntity1(
            id: UUID(),
            amount: 1000,
            date: Date(),
            note: "Salary"
        )
        
        let exp = expectation(description: "add expense")
        
        addUseCase.execute(expense)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail("Unexpected error \(error)")
                    }
                },
                receiveValue: {
                    XCTAssertEqual(self.repo.expense.count, 1)
                    XCTAssertEqual(self.repo.expense.first, expense)
                    exp.fulfill()
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    func testDeleteExpense_success() {
        let expense = ExpenseEntity1(
            id: UUID(),
            amount: 500,
            date: Date(),
            note: "Test"
        )
        
        // GIVEN existing income
        repo.expense = [expense]
        
        let exp = expectation(description: "delete expense")
        
        deleteUseCase.execute(id: expense.id)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail("Unexpected error \(error)")
                    }
                },
                receiveValue: {
                    XCTAssertTrue(self.repo.expense.isEmpty)
                    exp.fulfill()
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
}
