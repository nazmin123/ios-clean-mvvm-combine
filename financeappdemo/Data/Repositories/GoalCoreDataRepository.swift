//
//  GoalCoreDataRepository.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 16/12/25.
//

import Foundation
import Combine
import CoreData

public final class GoalCoreDataRepository: GoalRepository {
    
    private let context: NSManagedObjectContext
    
    public init(container: NSPersistentContainer) {
        self.context = container.viewContext
    }
    
    public func fetchGoals() -> AnyPublisher<[GoalEntity1], Error> {
        Future { promise in
            let request = NSFetchRequest<NSManagedObject>(entityName: "GoalEntity")
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            do {
                let results = try self.context.fetch(request)
                Task { @MainActor in
                    let models = results.compactMap(CoreDataMappers.goalEntity(from:))
                    promise(.success(models))
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    public func addOrUpdateGoal(_ goal: GoalEntity1) -> AnyPublisher<Void, Error> {
        Future { promise in
            let request = NSFetchRequest<NSManagedObject>(entityName: "GoalEntity")
            request.predicate = NSPredicate(format: "id == %@", goal.id as CVarArg)
            do {
                let object = try self.context.fetch(request).first ??
                NSEntityDescription.insertNewObject(
                    forEntityName: "GoalEntity",
                    into: self.context
                )
                
                object.setValue(goal.id, forKey: "id")
                object.setValue(goal.title, forKey: "title")
                object.setValue(goal.targetAmount, forKey: "targetAmount")
                object.setValue(goal.currentAmount, forKey: "currentAmount")
                
                try self.context.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    public func deleteGoal(id: UUID) -> AnyPublisher<Void, Error> {
        Future { promise in
            let request = NSFetchRequest<NSManagedObject>(entityName: "GoalEntity")
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
