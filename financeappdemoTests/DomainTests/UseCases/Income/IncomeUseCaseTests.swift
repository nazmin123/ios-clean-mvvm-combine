////
////  IncomeUseCaseTests.swift
////  financeappdemo
////
////  Created by Nazmin Parween on 15/12/25.
////
//
import XCTest
import Combine
@testable import financeappdemo

final class IncomeUseCaseTests: XCTestCase {
    
    // MUST be a property (not local)
    private var cancellables: Set<AnyCancellable>!
    private var repo: IncomeRepositoryMock!
    private var useCase: GetIncomesUseCaseImpl!
    private var addUseCase: AddIncomeUseCaseImpl!
    private var deleteUseCase: DeleteIncomeUseCaseImpl!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        repo = IncomeRepositoryMock()
        useCase = GetIncomesUseCaseImpl(repo: repo)
        addUseCase = AddIncomeUseCaseImpl(repo: repo)
        deleteUseCase = DeleteIncomeUseCaseImpl(repo: repo)
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
    deinit { print("IncomeUseCaseTests deinit") }
    
    func testGetIncomes_success() {
        let income = IncomeEntity1(
            id: UUID(),
            amount: 500,
            date: Date(),
            note: "Test"
        )
        repo.incomes = [income]
        
        let exp = expectation(description: "fetch incomes")
        
        useCase.execute()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail("Unexpected error \(error)")
                    }
                },
                receiveValue: { incomes in
                    XCTAssertEqual(incomes, [income])
                    exp.fulfill()
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func testAddIncome_success() {
        let income = IncomeEntity1(
            id: UUID(),
            amount: 1000,
            date: Date(),
            note: "Salary"
        )
        
        let exp = expectation(description: "add income")
        
        addUseCase.execute(income)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail("Unexpected error \(error)")
                    }
                },
                receiveValue: {
                    XCTAssertEqual(self.repo.incomes.count, 1)
                    XCTAssertEqual(self.repo.incomes.first, income)
                    exp.fulfill()
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    func testDeleteIncome_success() {
        let income = IncomeEntity1(
            id: UUID(),
            amount: 500,
            date: Date(),
            note: "Test"
        )
        
        // GIVEN existing income
        repo.incomes = [income]
        
        let exp = expectation(description: "delete income")
        
        deleteUseCase.execute(id: income.id)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail("Unexpected error \(error)")
                    }
                },
                receiveValue: {
                    XCTAssertTrue(self.repo.incomes.isEmpty)
                    exp.fulfill()
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
}



