//
//  TestPersistenceController.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 15/12/25.
//

import CoreData
import XCTest
@testable import financeappdemo


final class TestPersistenceController {
    static func makeContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "financeappdemo")
        let desc = NSPersistentStoreDescription()
        desc.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [desc]
        
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        return container
    }
}
