
import XCTest
import Combine
@testable import ProductsListApp

final class ProductRepositoryTests: XCTestCase {

    var mockRepository: MockProductsRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        mockRepository = MockProductsRepository()
        cancellables = []
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        mockRepository = nil
        cancellables = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetProductSuccessRepository() {
        let expectedProducts = [Products(id: 0, title: "Product 1", price: 20.0, description: "Product 1 Description", category: "jewellery", image: "image", rating: Rating(rate: 2.5, count: 10)),
                                Products(id: 1, title: "Product 2", price: 20.0, description: "Product 2 Description", category: "men's clothing", image: "image", rating: Rating(rate: 3.5, count: 20))
        ]
        mockRepository.mockProducts = expectedProducts
        mockRepository.shouldReturnError = false
     
        let expectation = self.expectation(description: "Products fetched successfully")
        mockRepository.getProducts()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { products in
                // Then
                XCTAssertEqual(products, expectedProducts)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetProductFailureRepository() {
        // Given
        mockRepository.shouldReturnError = true
        // When
        let expectation = self.expectation(description: "Products fetch failed")
        mockRepository.getProducts()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
