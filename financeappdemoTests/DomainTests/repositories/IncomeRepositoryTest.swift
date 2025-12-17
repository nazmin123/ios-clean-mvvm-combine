////
////  FinancialRepositoryTests.swift
////  financeappdemo
////
////  Created by Nazmin Parween on 15/12/25.
////

import XCTest
import Combine
@testable import financeappdemo

final class IncomeRepositoryTest: XCTestCase {
    
    var repo: IncomeCoreDataRepository!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        let container = TestPersistenceController.makeContainer()
        repo = IncomeCoreDataRepository(container: container)
    }
    
    func test_addAndFetchIncome() {
        let exp = expectation(description: "Income saved & fetched")
        let income = IncomeEntity1.mock(amount: 500)
        
        repo.addIncome(income)
            .flatMap { self.repo.fetchIncomes() }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { incomes in
                XCTAssertEqual(incomes.count, 1)
                XCTAssertEqual(incomes.first?.amount, 500)
                exp.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_deleteIncome_removesItem() {
        let exp = expectation(description: "Income deleted")
        let income = IncomeEntity1.mock()
        
        repo.addIncome(income)
            .flatMap { self.repo.deleteIncome(id: income.id) }
            .flatMap { self.repo.fetchIncomes() }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { incomes in
                XCTAssertTrue(incomes.isEmpty)
                exp.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
    }
}
