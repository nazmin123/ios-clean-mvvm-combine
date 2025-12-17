////
////  CoreDataMappersTests.swift
////  financeappdemo
////
////  Created by Nazmin Parween on 15/12/25.
////
//
import XCTest
import CoreData
@testable import financeappdemo

final class CoreDataMappersTests: XCTestCase {

    var context: NSManagedObjectContext!

    override func setUp() {
        context = CoreDataTestStack.makeContext()
    }

    override func tearDown() {
        context = nil
    }

    func test_incomeEntity_mapping_success() {
        let id = UUID()
        let date = Date()

        let mo = NSEntityDescription.insertNewObject(
            forEntityName: "IncomeEntity",
            into: context
        )

        mo.setValue(id, forKey: "id")
        mo.setValue(100.0, forKey: "amount")
        mo.setValue(date, forKey: "date")
        mo.setValue("Salary", forKey: "note")

        let entity = CoreDataMappers.incomeEntity(from: mo)

        XCTAssertNotNil(entity)
        XCTAssertEqual(entity?.id, id)
        XCTAssertEqual(entity?.amount, 100)
        XCTAssertEqual(entity?.note, "Salary")
    }

    func test_incomeEntity_returnsNil_whenMissingRequiredFields() {
        let mo = NSEntityDescription.insertNewObject(
            forEntityName: "IncomeEntity",
            into: context
        )

        // No values set
        let entity = CoreDataMappers.incomeEntity(from: mo)

        XCTAssertNil(entity)
    }
}

