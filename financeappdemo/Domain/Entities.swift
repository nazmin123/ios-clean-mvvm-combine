//
//  Entities.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 01/12/25.
//

import Foundation

public struct IncomeEntity1: Identifiable, Equatable {
    public let id: UUID
    public var amount: Double
    public var date: Date
    public var note: String?
}

public struct ExpenseEntity1: Identifiable, Equatable {
    public let id: UUID
    public var amount: Double
    public var date: Date
    public var note: String?
}

public struct GoalEntity1: Identifiable, Equatable {
    public let id: UUID
    public var title: String
    public var targetAmount: Double
    public var currentAmount: Double
}

struct Post: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
}
