//
//  ProductsViewModel.swift
//  ProductsListApp
//
//  Created by Rakhee Visakh on 07/05/25.
//

import UIKit
import Combine

enum ProductsViewModelError: Error, Equatable {
    case productFetch
}

enum ProductsViewModelState: Equatable {
    case loading
    case finishedLoading
    case error(ProductsViewModelError)
}

final class ProductsViewModel {
    private let productsService: ProductsRepositoryProtocol
    @Published var products:[Products] = []
    @Published private(set) var state: ProductsViewModelState = .loading
    private var cancellables: Set<AnyCancellable> = []
    var categoryName:String = ""
    
    init(productsService: ProductsRepositoryProtocol = ProductsRepository(), categoryName:String) {
        self.productsService = productsService
        self.categoryName = categoryName
    }
    
    func getProducts() {
        state = .loading
        let productsListCompletionHandler: (Subscribers.Completion<Error>) -> Void = { completion in
            switch completion {
            case .finished:
                self.state = .finishedLoading
            case .failure(_):
                self.state = .error(.productFetch)
            }
        }
        let productsListValueHandler: ([Products]) -> Void = { products in
            self.products = products.filter { $0.category.lowercased() == self.categoryName.lowercased() }
        }
        
        self.productsService.getProducts()
            .sink(receiveCompletion: productsListCompletionHandler, receiveValue: productsListValueHandler)
            .store(in: &cancellables)
    }
}
