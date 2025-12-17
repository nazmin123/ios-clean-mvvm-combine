//
//  IncomeCoreDataRepository.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 16/12/25.
//

import Combine
import CoreData

public final class IncomeCoreDataRepository: IncomeRepository {
    
    private let context: NSManagedObjectContext
    
    public init(container: NSPersistentContainer) {
        self.context = container.viewContext
    }
    
    public func fetchIncomes() -> AnyPublisher<[IncomeEntity1], Error> {
        Future { promise in
            let request = NSFetchRequest<NSManagedObject>(entityName: "IncomeEntity")
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            do {
                let results = try self.context.fetch(request)
                Task { @MainActor in
                    let models = results.compactMap(CoreDataMappers.incomeEntity(from:))
                    promise(.success(models))
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    public func addIncome(_ income: IncomeEntity1) -> AnyPublisher<Void, Error> {
        Future { promise in
            let mo = NSEntityDescription.insertNewObject(
                forEntityName: "IncomeEntity",
                into: self.context
            )
            mo.setValue(income.id, forKey: "id")
            mo.setValue(income.amount, forKey: "amount")
            mo.setValue(income.date, forKey: "date")
            mo.setValue(income.note, forKey: "note")
            
            do {
                try self.context.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    public func deleteIncome(id: UUID) -> AnyPublisher<Void, Error> {
        Future { promise in
            let request = NSFetchRequest<NSManagedObject>(entityName: "IncomeEntity")
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
