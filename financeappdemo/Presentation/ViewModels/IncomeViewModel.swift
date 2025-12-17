//
//  IncomeViewModel.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 01/12/25.
//


import Foundation
import Combine

final class IncomeViewModel: ObservableObject {
    @Published var items: [IncomeEntity1] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let getIncomes: GetIncomesUseCase
    private let addIncome: AddIncomeUseCase
    private let deleteIncome: DeleteIncomeUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(getIncomes: GetIncomesUseCase,
         addIncome: AddIncomeUseCase,
         deleteIncome: DeleteIncomeUseCase) {
        self.getIncomes = getIncomes
        self.addIncome = addIncome
        self.deleteIncome = deleteIncome
    }
    
    func fetch() {
        isLoading = true
        getIncomes.execute()
            .sink(receiveCompletion: { [weak self] comp in
                self?.isLoading = false
                if case let .failure(err) = comp { self?.errorMessage = err.localizedDescription }
            }, receiveValue: { [weak self] items in
                self?.items = items
            })
            .store(in: &cancellables)
    }
    
    func add(amount: Double, date: Date = Date(), note: String? = nil) {
        let model = IncomeEntity1(id: UUID(), amount: amount, date: date, note: note)
        addIncome.execute(model)
            .sink(receiveCompletion: { comp in
                if case let .failure(err) = comp { print("Add income err:", err) }
            }, receiveValue: { [weak self] _ in
                self?.fetch()
            })
            .store(in: &cancellables)
    }
    
    func delete(id: UUID) {
        deleteIncome.execute(id: id)
            .sink(receiveCompletion: { comp in
                if case let .failure(err) = comp { print("Delete income err:", err) }
            }, receiveValue: { [weak self] _ in
                self?.fetch()
            })
            .store(in: &cancellables)
    }
}
