
import XCTest
import Combine
@testable import ProductsListApp

final class CategoryViewModelTests: XCTestCase {
    var mockRepository: MockCategoryRepository!
    var viewModel: MockCategoryViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        mockRepository = MockCategoryRepository()
        viewModel = MockCategoryViewModel(categoryService: mockRepository)
        cancellables = []
    }

    override func tearDownWithError() throws {
        mockRepository = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testGetCategorySuccessVM() {
        // Given
        let expectedCategories = ["electronics","jewelery","men's clothing","women's clothing"]
        mockRepository.mockCategory = expectedCategories
        mockRepository.shouldReturnError = false
        
        // When
        let expectation = self.expectation(description: "Categories fetched successfully")
        
        viewModel.$category
            .dropFirst()
            .sink { category in
                XCTAssertEqual(category, expectedCategories)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.getCategories()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetCategoryFailureVM() {
        // Given
        mockRepository.shouldReturnError = true
        
        // When
        let expectation = self.expectation(description: "Categories fetch failed")
        
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { state in
                if state != .loading {
                    XCTAssertEqual(CategoryViewModelState.error(.categoryFetch), state)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.getCategories()
        wait(for: [expectation], timeout: 1.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
