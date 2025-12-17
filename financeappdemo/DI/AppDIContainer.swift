//
//  AppDIContainer.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 01/12/25.
//

// DI/AppDIContainer.swift
import Foundation
import Combine
import CoreData

final class AppDIContainer: ObservableObject {
    // Shared infra
    let persistenceContainer: NSPersistentContainer
    let urlSession: URLSession
    lazy var apiService: URLSessionAPIService = URLSessionAPIService()
    
    
    // Repositories
    lazy var incomeRepository: IncomeRepository =
    IncomeCoreDataRepository(container: persistenceContainer)
    
    lazy var expenseRepository: ExpenseRepository =
    ExpenseCoreDataRepository(container: persistenceContainer)
    
    lazy var goalRepository: GoalRepository =
    GoalCoreDataRepository(container: persistenceContainer)
    
    lazy var postRepository: PostRepository =
    PostRepositoryImpl(api: apiService)
    
    // Use cases
    lazy var getIncomesUseCase: GetIncomesUseCase = GetIncomesUseCaseImpl(repo: incomeRepository)
    lazy var addIncomeUseCase: AddIncomeUseCase = AddIncomeUseCaseImpl(repo: incomeRepository)
    lazy var deleteIncomeUseCase: DeleteIncomeUseCase = DeleteIncomeUseCaseImpl(repo: incomeRepository)
    
    lazy var getExpensesUseCase: GetExpensesUseCase = GetExpenseUseCaseImpl(repo: expenseRepository)
    lazy var addExpenseUseCase: AddExpenseUseCase = AddExpenseUseCaseImpl(repo: expenseRepository)
    lazy var deleteExpenseUseCase: DeleteExpenseUseCase = DeleteExpenseUseCaseImpl(repo: expenseRepository)
    
    lazy var getGoalsUseCase: GetGoalsUseCase = GetGoalsUseCaseImpl(repo: goalRepository)
    lazy var addOrUpdateGoalUseCase: AddOrUpdateGoalUseCase = AddOrUpdateGoalUseCaseImpl(repo: goalRepository)
    lazy var deleteGoalUseCase: DeleteGoalUseCase = DeleteGoalUseCaseImpl(repo: goalRepository)
    
    
    lazy var fetchPostsUseCase: FetchPostsUseCaseProtocol =
    FetchPostsUseCase(repository: postRepository)
    
    init(
        container: NSPersistentContainer,
        session: URLSession = .shared
    ) {
        self.persistenceContainer = container
        self.urlSession = session
    }
    
    // ViewModel factories
    func makeDashboardViewModel() -> DashboardViewModel {
        DashboardViewModel(getIncomes: getIncomesUseCase, getExpenses: getExpensesUseCase)
    }
    
    func makeIncomeViewModel() -> IncomeViewModel {
        IncomeViewModel(getIncomes: getIncomesUseCase,
                        addIncome: addIncomeUseCase,
                        deleteIncome: deleteIncomeUseCase)
    }
    
    func makeExpenseViewModel() -> ExpenseViewModel {
        ExpenseViewModel(getExpenses: getExpensesUseCase,
                         addExpense: addExpenseUseCase,
                         deleteExpense: deleteExpenseUseCase)
    }
    
    func makeGoalViewModel() -> GoalViewModel {
        GoalViewModel(getGoals: getGoalsUseCase,
                      addOrUpdateGoal: addOrUpdateGoalUseCase,
                      deleteGoal: deleteGoalUseCase)
    }
    
    func makePostListViewModel() -> PostViewModel {
        PostViewModel(fetchPostsUseCase: fetchPostsUseCase)
    }
    
}
