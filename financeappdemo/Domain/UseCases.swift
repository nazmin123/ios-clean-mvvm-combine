//
//  UseCases.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 01/12/25.
//


import Combine
import Foundation

// Income
public protocol GetIncomesUseCase { func execute() -> AnyPublisher<[IncomeEntity1], Error> }
public protocol AddIncomeUseCase { func execute(_ i: IncomeEntity1) -> AnyPublisher<Void, Error> }
public protocol DeleteIncomeUseCase { func execute(id: UUID) -> AnyPublisher<Void, Error> }

// Expenses
public protocol GetExpensesUseCase { func execute() -> AnyPublisher<[ExpenseEntity1], Error> }
public protocol AddExpenseUseCase { func execute(_ e: ExpenseEntity1) -> AnyPublisher<Void, Error> }
public protocol DeleteExpenseUseCase { func execute(id: UUID) -> AnyPublisher<Void, Error> }

// Goals
public protocol GetGoalsUseCase { func execute() -> AnyPublisher<[GoalEntity1], Error> }
public protocol AddOrUpdateGoalUseCase { func execute(_ g: GoalEntity1) -> AnyPublisher<Void, Error> }
public protocol DeleteGoalUseCase { func execute(id: UUID) -> AnyPublisher<Void, Error> }

//Posts
protocol FetchPostsUseCaseProtocol {
    func execute() -> AnyPublisher<[Post], Error>
}
