//
//  Untitled.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 01/12/25.
//

import Foundation
import Combine

final class ExpenseViewModel: ObservableObject {
    @Published var items: [ExpenseEntity1] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let getExpenses: GetExpensesUseCase
    private let addExpense: AddExpenseUseCase
    private let deleteExpense: DeleteExpenseUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(getExpenses: GetExpensesUseCase,
         addExpense: AddExpenseUseCase,
         deleteExpense: DeleteExpenseUseCase) {
        self.getExpenses = getExpenses
        self.addExpense = addExpense
        self.deleteExpense = deleteExpense
    }
    
    func fetch() {
        isLoading = true
        getExpenses.execute()
            .sink(receiveCompletion: { [weak self] comp in
                self?.isLoading = false
                if case let .failure(err) = comp { self?.errorMessage = err.localizedDescription }
            }, receiveValue: { [weak self] items in
                self?.items = items
            })
            .store(in: &cancellables)
    }
    
    func add(amount: Double, date: Date = Date(), note: String? = nil) {
        let model = ExpenseEntity1(id: UUID(), amount: amount, date: date, note: note)
        addExpense.execute(model)
            .sink(receiveCompletion: { comp in
                if case let .failure(err) = comp { print("Add expense err:", err) }
            }, receiveValue: { [weak self] _ in
                self?.fetch()
            })
            .store(in: &cancellables)
    }
    
    func delete(id: UUID) {
        deleteExpense.execute(id: id)
            .sink(receiveCompletion: { comp in
                if case let .failure(err) = comp { print("Delete expense err:", err) }
            }, receiveValue: { [weak self] _ in
                self?.fetch()
            })
            .store(in: &cancellables)
    }
}

