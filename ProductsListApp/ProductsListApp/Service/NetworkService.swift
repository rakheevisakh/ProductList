//
//  NetworkService.swift
//  ProductsListApp
//
//  Created by Rakhee Visakh on 07/05/25.
//

import Foundation
import Combine


protocol APIService {
    associatedtype Model : Codable
    func fetchProducts(from url: URL) -> AnyPublisher<Model, Error>
}

class NetworkService<T: Codable>: APIService {
    private let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchProducts(from url: URL) -> AnyPublisher<T, Error> {
        self.session.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
