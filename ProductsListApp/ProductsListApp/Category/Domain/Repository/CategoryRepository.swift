//
//  CategoryRepository.swift
//  ProductsListApp
//
//  Created by Rakhee Visakh on 07/05/25.
//

import Foundation
import Combine

protocol CategoryRepositoryProtocol {
    func getCategory() -> AnyPublisher<[String], Error>
}

class CategoryRepository: CategoryRepositoryProtocol {
   
    private let networkService: NetworkService<[String]>
    private let url = URL(string: AppConstants.baseUrl + AppConstants.categoryPath)!
    
    init(networkService: NetworkService<[String]> = NetworkService<[String]>()) {
        self.networkService = networkService
    }
    
    func getCategory() -> AnyPublisher<[String], Error> {
        networkService.fetchProducts(from: url)
    }
    
}
