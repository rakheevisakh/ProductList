
import XCTest
import Combine
@testable import ProductsListApp

final class ProductsViewModelTests: XCTestCase {
    var mockRepository: MockProductsRepository!
    var viewModel: MockProductViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        mockRepository = MockProductsRepository()
        viewModel = MockProductViewModel(productService: mockRepository)
        cancellables = []
    }

    override func tearDownWithError() throws {
        mockRepository = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testGetProductsSuccessVM() {
       
        let expectedProducts = [Products(id: 0, title: "Product 1", price: 20.0, description: "Product 1 Description", category: "jewellery", image: "image", rating: Rating(rate: 2.5, count: 10)),
                                Products(id: 1, title: "Product 2", price: 20.0, description: "Product 2 Description", category: "men's clothing", image: "image", rating: Rating(rate: 3.5, count: 20))
        ]
        mockRepository.mockProducts = expectedProducts
        mockRepository.shouldReturnError = false
        
        let expectation = self.expectation(description: "Products fetched successfully")
        
        viewModel.$products
            .dropFirst()
            .sink { products in
                XCTAssertEqual(products, expectedProducts, "Products should match expected data")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.getProducts()
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetProductsFailureVM() {
        mockRepository.shouldReturnError = true
       
        let expectation = self.expectation(description: "Products fetch failed")
        
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { state in
                if state != .loading {
                    XCTAssertEqual(ProductsViewModelState.error(.productFetch), state)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.getProducts()
        wait(for: [expectation], timeout: 1.0)
    }
}
