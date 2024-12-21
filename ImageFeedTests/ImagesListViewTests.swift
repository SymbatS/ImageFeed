@testable import ImageFeed
import XCTest

final class ImagesListViewControllerTests: XCTestCase {
    var viewController: ImagesListViewController!
    var presenterMock: ImageListViewPresenterProtocolMock!
    var serviceMock: ImagesListServiceMock!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController
        
        presenterMock = ImageListViewPresenterProtocolMock()
        serviceMock = ImagesListServiceMock()
        
        viewController.presenter = presenterMock
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        presenterMock = nil
        serviceMock = nil
        super.tearDown()
    }
    
    func testViewDidLoad() {
        // Act
        viewController.viewDidLoad()
        
        // Assert
        XCTAssertTrue(presenterMock.viewDidLoadCalled, "Метод viewDidLoad у презентера не был вызван.")
    }
    
    func testUpdateTableView() {
        // Arrange
        serviceMock.photos = [Photo(
            id: "1",
            size: CGSize(width: 1024, height: 768),
            createdAt: Date(),
            welcomeDescription: "A sample photo",
            thumbImageURL: "url",
            largeImageURL: "url",
            isLiked: false
        )]
        
        viewController.service = serviceMock
        viewController.updateTableView()
        
        // Act
        let rows = viewController.tableView.numberOfRows(inSection: 0)
        
        // Assert
        XCTAssertEqual(rows, 1, "Количество строк в таблице неверное.")
    }
    
}
