//
//  PostMockHelper.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 14/12/25.
//

@testable import financeappdemo

extension Post {
    static func makeMock(
        id: Int = 1,
        title: String = "Test Title",
        body: String = "Test Body"
    ) -> Post {
        Post(id: id, title: title, body: body)
    }
}
