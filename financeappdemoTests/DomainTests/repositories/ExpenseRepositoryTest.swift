//
//  ExpenseRepositoryTest.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 17/12/25.
//

import XCTest
import Combine
@testable import financeappdemo

final class ExpenseRepositoryTest: XCTestCase {
    
    var repo: ExpenseCoreDataRepository!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        let container = TestPersistenceController.makeContainer()
        repo = ExpenseCoreDataRepository(container: container)
    }
    
    func test_addAndFetchIncome() {
        let exp = expectation(description: "Expense saved & fetched")
        let expense = ExpenseEntity1.mock(amount: 500)
        
        repo.addExpense(expense)
            .flatMap { self.repo.fetchExpense() }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { expense in
                XCTAssertEqual(expense.count, 1)
                XCTAssertEqual(expense.first?.amount, 500)
                exp.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_deleteExpense_removesItem() {
        let exp = expectation(description: "Expense deleted")
        let expense = ExpenseEntity1.mock()
        
        repo.addExpense(expense)
            .flatMap { self.repo.deleteExpense(id: expense.id) }
            .flatMap { self.repo.fetchExpense() }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { expense in
                XCTAssertTrue(expense.isEmpty)
                exp.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
    }
}
