//
//  CoreDataMappers.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 01/12/25.
//

import Foundation
import CoreData

// Simple mapping helpers between NSManagedObject and Entities
enum CoreDataMappers {
    static func incomeEntity(from mo: NSManagedObject) -> IncomeEntity1? {
        guard
            let id = mo.value(forKey: "id") as? UUID,
            let date = mo.value(forKey: "date") as? Date,
            let amount = mo.value(forKey: "amount") as? Double
        else { return nil }
        let note = mo.value(forKey: "note") as? String
        return IncomeEntity1(id: id, amount: amount, date: date, note: note)
    }
    
    static func expenseEntity(from mo: NSManagedObject) -> ExpenseEntity1? {
        guard
            let id = mo.value(forKey: "id") as? UUID,
            let date = mo.value(forKey: "date") as? Date,
            let amount = mo.value(forKey: "amount") as? Double
        else { return nil }
        let note = mo.value(forKey: "note") as? String
        return ExpenseEntity1(id: id, amount: amount, date: date, note: note)
    }
    
    static func goalEntity(from mo: NSManagedObject) -> GoalEntity1? {
        guard
            let id = mo.value(forKey: "id") as? UUID,
            let title = mo.value(forKey: "title") as? String,
            let target = mo.value(forKey: "targetAmount") as? Double,
            let current = mo.value(forKey: "currentAmount") as? Double
        else { return nil }
        return GoalEntity1(id: id, title: title, targetAmount: target, currentAmount: current)
    }
}
