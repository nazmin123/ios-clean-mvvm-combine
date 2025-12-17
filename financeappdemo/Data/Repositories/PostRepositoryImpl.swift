//
//  PostRepositoryImpl.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 13/12/25.
//

import Combine

final class PostRepositoryImpl: PostRepository {
    
    private let api: APIService
    
    init(api: APIService) {
        self.api = api
    }
    
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        api.get("https://jsonplaceholder.typicode.com/posts")
    }
}

