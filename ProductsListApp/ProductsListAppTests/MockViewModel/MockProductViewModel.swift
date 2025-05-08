
import XCTest
import Combine
@testable import ProductsListApp

final class MockProductViewModel {
    private let productService: ProductsRepositoryProtocol
    @Published var products = [Products]()
    @Published private(set) var state: ProductsViewModelState = .loading
    private var cancellables: Set<AnyCancellable> = []
    
    init(productService: ProductsRepositoryProtocol = ProductsRepository()) {
        self.productService = productService
    }
    
    func getProducts() {
        state = .loading
        let productListCompletionHandler: (Subscribers.Completion<Error>) -> Void = { completion in
            switch completion {
            case .finished:
                self.state = .finishedLoading
            case .failure(_):
                self.state = .error(.productFetch)
            }
        }
        let productListValueHandler: ([Products]) -> Void = { [weak self] products in
            self?.products = products
        }
        
        self.productService.getProducts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: productListCompletionHandler, receiveValue: productListValueHandler)
            .store(in: &cancellables)
    }
}
