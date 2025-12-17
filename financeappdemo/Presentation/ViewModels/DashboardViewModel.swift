//
//  DashboardViewModel.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 01/12/25.
//

import Foundation
import Combine


final class DashboardViewModel: ObservableObject {
    @Published var totalIncome: Double = 0
    @Published var totalExpense: Double = 0
    @Published var balance: Double = 0
    
    private var cancellables = Set<AnyCancellable>()
    private let getIncomes: GetIncomesUseCase
    private let getExpenses: GetExpensesUseCase
    
    init(getIncomes: GetIncomesUseCase, getExpenses: GetExpensesUseCase) {
        self.getIncomes = getIncomes
        self.getExpenses = getExpenses
    }
    
    func refresh() {
        Publishers.Zip(getIncomes.execute().replaceError(with: []),
                       getExpenses.execute().replaceError(with: []))
        .receive(on: DispatchQueue.main)
        .sink { [weak self] incomes, expenses in
            self?.totalIncome = incomes.reduce(0) { $0 + $1.amount }
            self?.totalExpense = expenses.reduce(0) { $0 + $1.amount }
            self?.balance = (self?.totalIncome ?? 0) - (self?.totalExpense ?? 0)
        }
        .store(in: &cancellables)
    }
}

