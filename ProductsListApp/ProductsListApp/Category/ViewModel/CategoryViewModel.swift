//
//  CategoryViewModel.swift
//  ProductsListApp
//
//  Created by Rakhee Visakh on 07/05/25.
//

import Foundation
import Combine

enum CategoryViewModelError: Error, Equatable {
    case categoryFetch
}

enum CategoryViewModelState: Equatable {
    case loading
    case finishedLoading
    case error(CategoryViewModelError)
}

final class CategoryViewModel {
    private let categoryService: CategoryRepositoryProtocol
    @Published var category = [String]()
    @Published private(set) var state: CategoryViewModelState = .loading
    private var cancellables: Set<AnyCancellable> = []
    
    init( categoryService: CategoryRepositoryProtocol = CategoryRepository()) {
        self.categoryService = categoryService
    }
    
    func getCategories() {
        state = .loading
        let categoryListCompletionHandler: (Subscribers.Completion<Error>) -> Void = { completion in
            switch completion {
            case .finished:
                self.state = .finishedLoading
            case .failure(_):
                self.state = .error(.categoryFetch)
            }
        }
        let categoryListValueHandler: ([String]) -> Void = { [weak self] category in
            self?.category = category
        }
        
        self.categoryService.getCategory()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: categoryListCompletionHandler, receiveValue: categoryListValueHandler)
            .store(in: &cancellables)
    }
}
