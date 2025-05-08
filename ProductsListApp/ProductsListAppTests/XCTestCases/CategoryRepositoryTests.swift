
import XCTest
import Combine
@testable import ProductsListApp

final class CategoryRepositoryTests: XCTestCase {
    var mockRepository: MockCategoryRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        mockRepository = MockCategoryRepository()
        cancellables = []
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        mockRepository = nil
        cancellables = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetCategorySuccessRepository() {
        // Given
        let expectedCategories = ["electronics","jewellery","men's clothing","women's clothing"]
        mockRepository.mockCategory = expectedCategories
        mockRepository.shouldReturnError = false
        
        // When
        let expectation = self.expectation(description: "Categories fetched successfully")
        mockRepository.getCategory()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { categories in
                // Then
                XCTAssertEqual(categories, expectedCategories)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetCategoryFailureRepository() {
        // Given
        mockRepository.shouldReturnError = true
        // When
        let expectation = self.expectation(description: "Categories fetch failed")
        mockRepository.getCategory()
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
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
