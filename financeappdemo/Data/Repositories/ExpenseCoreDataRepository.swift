//
//  ExpenseCoreDataRepository.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 16/12/25.
//

import Combine
import CoreData

public final class ExpenseCoreDataRepository: ExpenseRepository {
    
    private let context: NSManagedObjectContext
    
    public init(container: NSPersistentContainer) {
        self.context = container.viewContext
    }
    
    public func fetchExpense() -> AnyPublisher<[ExpenseEntity1], Error> {
        Future { promise in
            let request = NSFetchRequest<NSManagedObject>(entityName: "ExpenseEntity")
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            do {
                let results = try self.context.fetch(request)
                Task { @MainActor in
                    let models = results.compactMap(CoreDataMappers.expenseEntity(from:))
                    promise(.success(models))
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    public func addExpense(_ expense: ExpenseEntity1) -> AnyPublisher<Void, Error> {
        Future { promise in
            let mo = NSEntityDescription.insertNewObject(
                forEntityName: "ExpenseEntity",
                into: self.context
            )
            mo.setValue(expense.id, forKey: "id")
            mo.setValue(expense.amount, forKey: "amount")
            mo.setValue(expense.date, forKey: "date")
            mo.setValue(expense.note, forKey: "note")
            do {
                try self.context.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    public func deleteExpense(id: UUID) -> AnyPublisher<Void, Error> {
        Future { promise in
            let request = NSFetchRequest<NSManagedObject>(entityName: "ExpenseEntity")
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            do {
                if let object = try self.context.fetch(request).first {
                    self.context.delete(object)
                    try self.context.save()
                }
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
