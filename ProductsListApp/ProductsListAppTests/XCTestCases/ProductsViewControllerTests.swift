
import XCTest
import Combine
@testable import ProductsListApp

final class ProductsViewControllerTests: XCTestCase {

    var viewController: ProductsViewController!
    var mockViewModel: ProductsViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        mockViewModel = ProductsViewModel(productsService: MockProductsRepository(), categoryName: "")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "ProductsViewController") as? ProductsViewController
        viewController.loadViewIfNeeded()
        viewController.productsViewModel = mockViewModel
        cancellables = []
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        viewController = nil
        mockViewModel = nil
        cancellables = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewDidLoadCallsGetProducts() {
        // Given
        let expectation = self.expectation(description: "Fetched products")
        mockViewModel.$products
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        viewController.viewDidLoad()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateSectionsReloadsProductListTableView() {
        
        let products = [Products(id: 0, title: "Product 1", price: 20.0, description: "Product 1 Description", category: "jewellery", image: "image", rating: Rating(rate: 2.5, count: 10)),
                        Products(id: 1, title: "Product 2", price: 20.0, description: "Product 2 Description", category: "men's clothing", image: "image", rating: Rating(rate: 3.5, count: 20))
        ]
        viewController.updateSections(products: products)
        let snapshot = viewController.dataSource.snapshot()
        XCTAssertEqual(snapshot.numberOfItems, products.count)
        XCTAssertEqual(snapshot.itemIdentifiers, products)
    }

}
