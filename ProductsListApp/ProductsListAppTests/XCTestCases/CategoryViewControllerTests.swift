import XCTest
import Combine
@testable import ProductsListApp

final class CategoryViewControllerTests: XCTestCase {
    
    var viewController: CategoryListViewController!
    var mockViewModel: CategoryViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        mockViewModel = CategoryViewModel(categoryService: MockCategoryRepository())
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "CategoryListViewController") as? CategoryListViewController
        viewController.loadViewIfNeeded()
        viewController.categoryViewModel = mockViewModel
        cancellables = []
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        viewController = nil
        mockViewModel = nil
        cancellables = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewDidLoadCallsGetCategory() {
        // Given
        let expectation = self.expectation(description: "Fetched categories")
        mockViewModel.$category
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

    func testUpdateSectionsReloadsTableView() {
        let categories = ["electronics","jewellery","men's clothing","women's clothing"]
        viewController.updateSections(category: categories)
        let snapshot = viewController.dataSource.snapshot()
        XCTAssertEqual(snapshot.numberOfItems, categories.count)
        XCTAssertEqual(snapshot.itemIdentifiers, categories)
    }
    
    func testDidSelectRow_PushesProductVC() {
        // Given
        let categories = ["electronics","jewellery","men's clothing","women's clothing"]
        viewController.updateSections(category: categories)
        let indexPath = IndexPath(row: 0, section: 0)
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.tableView(viewController.tblViewCategory, didSelectRowAt: indexPath)
        XCTAssertTrue(navigationController.topViewController is ProductsViewController)
    }

}
