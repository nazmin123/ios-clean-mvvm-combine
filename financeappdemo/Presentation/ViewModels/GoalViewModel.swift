//
//  GoalViewModel.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 01/12/25.
//

import Foundation
import Combine

final class GoalViewModel: ObservableObject {
    @Published var items: [GoalEntity1] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let getGoals: GetGoalsUseCase
    private let addOrUpdateGoal: AddOrUpdateGoalUseCase
    private let deleteGoal: DeleteGoalUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(getGoals: GetGoalsUseCase,
         addOrUpdateGoal: AddOrUpdateGoalUseCase,
         deleteGoal: DeleteGoalUseCase) {
        self.getGoals = getGoals
        self.addOrUpdateGoal = addOrUpdateGoal
        self.deleteGoal = deleteGoal
    }
    
    func fetch() {
        isLoading = true
        getGoals.execute()
            .sink(receiveCompletion: { [weak self] comp in
                self?.isLoading = false
                if case let .failure(err) = comp { self?.errorMessage = err.localizedDescription }
            }, receiveValue: { [weak self] items in
                self?.items = items
            })
            .store(in: &cancellables)
    }
    
    func addOrUpdate(_ model: GoalEntity1) {
        addOrUpdateGoal.execute(model)
            .sink(receiveCompletion: { comp in
                if case let .failure(err) = comp { print("Goal err:", err) }
            }, receiveValue: { [weak self] _ in
                self?.fetch()
            })
            .store(in: &cancellables)
    }
    
    func delete(id: UUID) {
        deleteGoal.execute(id: id)
            .sink(receiveCompletion: { comp in
                if case let .failure(err) = comp { print("Delete goal err:", err) }
            }, receiveValue: { [weak self] _ in
                self?.fetch()
            })
            .store(in: &cancellables)
    }
    
    func addGoal(title: String, target: Double, current: Double) {
        let goal = GoalEntity1(
            id: UUID(),
            title: title,
            targetAmount: target,
            currentAmount: current
        )
        
        addOrUpdate(goal)
    }
    
}
