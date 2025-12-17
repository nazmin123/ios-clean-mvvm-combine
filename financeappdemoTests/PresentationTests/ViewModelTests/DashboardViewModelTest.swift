//
//  DashboardViewModelTest.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 15/12/25.
//
import XCTest
import Combine
@testable import financeappdemo

final class DashboardViewModelTests: XCTestCase {
    
    private var viewModel: DashboardViewModel!
    private var incomeUseCase: GetIncomesUseCaseMock!
    private var expenseUseCase: GetExpenseUseCaseMock!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        incomeUseCase = GetIncomesUseCaseMock()
        expenseUseCase = GetExpenseUseCaseMock()
        viewModel = DashboardViewModel(
            getIncomes: incomeUseCase,
            getExpenses: expenseUseCase
        )
    }
    
    override func tearDown() {
        cancellables.removeAll()
        cancellables = nil
        viewModel = nil
        incomeUseCase = nil
        expenseUseCase = nil
        super.tearDown()
    }
    func testRefresh_calculatesTotalsAndBalance() {
        // GIVEN
        incomeUseCase.result = [
            IncomeEntity1(id: UUID(), amount: 1000, date: Date(), note: nil),
            IncomeEntity1(id: UUID(), amount: 500, date: Date(), note: nil)
        ]
        
        expenseUseCase.result = [
            ExpenseEntity1(id: UUID(), amount: 400, date: Date(), note: nil),
            ExpenseEntity1(id: UUID(), amount: 100, date: Date(), note: nil)
        ]
        
        let exp = expectation(description: "dashboard updated")
        
        viewModel.$balance
            .dropFirst() // ignore initial 0
            .sink { balance in
                XCTAssertEqual(balance, 1000) // 1500 - 500
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        // WHEN
        viewModel.refresh()
        
        waitForExpectations(timeout: 1)
    }
    
    func testRefresh_withEmptyData_setsZeroValues() {
        // GIVEN
        incomeUseCase.result = []
        expenseUseCase.result = []
        
        let exp = expectation(description: "dashboard zero state")
        
        viewModel.$balance
            .dropFirst()
            .sink { balance in
                XCTAssertEqual(balance, 0)
                XCTAssertEqual(self.viewModel.totalIncome, 0)
                XCTAssertEqual(self.viewModel.totalExpense, 0)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        // WHEN
        viewModel.refresh()
        
        waitForExpectations(timeout: 1)
    }
    
    func testRefresh_negativeBalance() {
        // GIVEN
        incomeUseCase.result = [
            IncomeEntity1(id: UUID(), amount: 300, date: Date(), note: nil)
        ]
        
        expenseUseCase.result = [
            ExpenseEntity1(id: UUID(), amount: 500, date: Date(), note: nil)
        ]
        
        let exp = expectation(description: "negative balance")
        
        viewModel.$balance
            .dropFirst()
            .sink { balance in
                XCTAssertEqual(balance, -200)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        // WHEN
        viewModel.refresh()
        
        waitForExpectations(timeout: 1)
    }
    
    
}




