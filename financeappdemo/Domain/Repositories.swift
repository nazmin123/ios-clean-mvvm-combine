//
//  Repositories.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 01/12/25.
//


import Combine
import Foundation

public protocol IncomeRepository {
    func fetchIncomes() -> AnyPublisher<[IncomeEntity1], Error>
    func addIncome(_ income: IncomeEntity1) -> AnyPublisher<Void, Error>
    func deleteIncome(id: UUID) -> AnyPublisher<Void, Error>
}

public protocol ExpenseRepository {
    func fetchExpense() -> AnyPublisher<[ExpenseEntity1], Error>
    func addExpense(_ expense: ExpenseEntity1) -> AnyPublisher<Void, Error>
    func deleteExpense(id: UUID) -> AnyPublisher<Void, Error>
}

public protocol GoalRepository {
    func fetchGoals() -> AnyPublisher<[GoalEntity1], Error>
    func addOrUpdateGoal(_ goal: GoalEntity1) -> AnyPublisher<Void, Error>
    func deleteGoal(id: UUID) -> AnyPublisher<Void, Error>
}


protocol PostRepository {
    func fetchPosts() -> AnyPublisher<[Post], Error>
}


