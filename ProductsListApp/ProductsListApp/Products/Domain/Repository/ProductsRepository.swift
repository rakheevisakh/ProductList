//
//  ProductsRepository.swift
//  ProductsListApp
//
//  Created by Rakhee Visakh on 07/05/25.
//

import Foundation
import Combine

protocol ProductsRepositoryProtocol {
    func getProducts() -> AnyPublisher<[Products], Error>
}

class ProductsRepository: ProductsRepositoryProtocol {
   
    private let networkService: NetworkService<[Products]>
    private let url = URL(string: AppConstants.baseUrl + AppConstants.productPath)!
    
    init(networkService: NetworkService<[Products]> = NetworkService<[Products]>()) {
        self.networkService = networkService
    }
    
    func getProducts() -> AnyPublisher<[Products], Error> {
        networkService.fetchProducts(from: url)
    }
    
}
