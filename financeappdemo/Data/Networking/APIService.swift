//
//  APIService.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 13/12/25.
//

import Combine
import Foundation

protocol APIService {
    func get<T: Decodable>(_ urlString: String) -> AnyPublisher<T, Error>
}

final class URLSessionAPIService: APIService {
    
    func get<T: Decodable>(_ urlString: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let http = response as? HTTPURLResponse,
                      (200...299).contains(http.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

