//
//  APIServiceMock.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 14/12/25.
//

import Combine
import Foundation
@testable import financeappdemo

final class APIServiceMock: APIService {
    
    var result: AnyPublisher<Data, Error>?
    
    func get<T: Decodable>(_ urlString: String) -> AnyPublisher<T, Error> {
        guard let result = result else {
            return Fail(error: URLError(.unknown))
                .eraseToAnyPublisher()
        }
        
        return result
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
