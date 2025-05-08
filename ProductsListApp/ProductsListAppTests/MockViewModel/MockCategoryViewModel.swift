import XCTest
import Combine
@testable import ProductsListApp

final class MockCategoryViewModel {
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
