//
//  UseCaseImpl.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 01/12/25.
//

import Foundation
import Combine

// Concrete use case implementations that wrap the repository.
// This keeps view models independent of the repository implementation.

public final class GetIncomesUseCaseImpl: GetIncomesUseCase {
    private let repo: IncomeRepository
    public init(repo: IncomeRepository) { self.repo = repo }
    public func execute() -> AnyPublisher<[IncomeEntity1], Error> { repo.fetchIncomes() }
}

public final class AddIncomeUseCaseImpl: AddIncomeUseCase {
    private let repo:IncomeRepository
    
    public init(repo: IncomeRepository
    ) { self.repo = repo }
    public func execute(_ i: IncomeEntity1) -> AnyPublisher<Void, Error> { repo.addIncome(i) }
}

public final class DeleteIncomeUseCaseImpl: DeleteIncomeUseCase {
    private let repo: IncomeRepository
    
    public init(repo: IncomeRepository
    ) { self.repo = repo }
    public func execute(id: UUID) -> AnyPublisher<Void, Error> { repo.deleteIncome(id: id) }
}

// Expenses
public final class GetExpenseUseCaseImpl: GetExpensesUseCase {
    private let repo: ExpenseRepository
    public init(repo: ExpenseRepository) { self.repo = repo }
    public func execute() -> AnyPublisher<[ExpenseEntity1], Error> { repo.fetchExpense() }
}

public final class AddExpenseUseCaseImpl: AddExpenseUseCase {
    private let repo: ExpenseRepository
    public init(repo: ExpenseRepository) { self.repo = repo }
    public func execute(_ e: ExpenseEntity1) -> AnyPublisher<Void, Error> { repo.addExpense(e) }
}

public final class DeleteExpenseUseCaseImpl: DeleteExpenseUseCase {
    private let repo: ExpenseRepository
    public init(repo: ExpenseRepository) { self.repo = repo }
    public func execute(id: UUID) -> AnyPublisher<Void, Error> { repo.deleteExpense(id: id) }
}

// Goals
public final class GetGoalsUseCaseImpl: GetGoalsUseCase {
    private let repo: GoalRepository
    public init(repo: GoalRepository) { self.repo = repo }
    public func execute() -> AnyPublisher<[GoalEntity1], Error> { repo.fetchGoals() }
}

public final class AddOrUpdateGoalUseCaseImpl: AddOrUpdateGoalUseCase {
    private let repo: GoalRepository
    public init(repo: GoalRepository) { self.repo = repo }
    public func execute(_ g: GoalEntity1) -> AnyPublisher<Void, Error> { repo.addOrUpdateGoal(g) }
}

public final class DeleteGoalUseCaseImpl: DeleteGoalUseCase {
    private let repo: GoalRepository
    public init(repo: GoalRepository) { self.repo = repo }
    public func execute(id: UUID) -> AnyPublisher<Void, Error> { repo.deleteGoal(id: id) }
}

//Posts
final class FetchPostsUseCase: FetchPostsUseCaseProtocol {
    
    private let repository: PostRepository
    
    init(repository: PostRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Post], Error> {
        repository.fetchPosts()
    }
}

