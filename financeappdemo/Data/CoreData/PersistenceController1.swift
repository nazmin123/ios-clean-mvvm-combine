//
//  PersistenceController.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 01/12/25.
//

import CoreData

public final class PersistenceController1 {
    public static let shared = PersistenceController1()
    public let container: NSPersistentContainer
    
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "financeappdemo")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { desc, error in
            if let err = error {
                fatalError("Unresolved Core Data error: \(err)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
