//
//  EntitiesMock.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 15/12/25.
//
import Foundation
@testable import financeappdemo

extension IncomeEntity1 {
    static func mock(
        id: UUID = UUID(),
        amount: Double = 100,
        date: Date = Date(),
        note: String? = "Test"
    ) -> IncomeEntity1 {
        IncomeEntity1(id: id, amount: amount, date: date, note: note)
    }
}

extension ExpenseEntity1 {
    static func mock(
        id: UUID = UUID(),
        amount: Double = 50,
        date: Date = Date(),
        note: String? = "Test"
    ) -> ExpenseEntity1 {
        ExpenseEntity1(id: id, amount: amount, date: date, note: note)
    }
}

extension GoalEntity1 {
    static func mock(
        id: UUID = UUID(),
        title: String = "Goal",
        target: Double = 1000,
        current: Double = 200
    ) -> GoalEntity1 {
        GoalEntity1(id: id, title: title, targetAmount: target, currentAmount: current)
    }
}
