//
//  Untitled.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 15/12/25.
//

import CoreData
import XCTest

final class CoreDataTestStack {

    static func makeContext() -> NSManagedObjectContext {
        let modelURL = Bundle.main.url(
            forResource: "financeappdemo",
            withExtension: "momd"
        )!

        let model = NSManagedObjectModel(contentsOf: modelURL)!
        let container = NSPersistentContainer(
            name: "financeappdemo",
            managedObjectModel: model
        )

        let desc = NSPersistentStoreDescription()
        desc.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [desc]

        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }

        return container.viewContext
    }
}
