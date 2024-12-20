@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTest {
    
    func testControllerCallsViewDidLoad() {
        //given
        let presenter = ProfileViewPresenter(profileService: ProfileServiceSpy(), profileImageService: ProfileImageServiceSpy())
        let viewController = ProfileViewController(presenter: presenter)
        presenter.view = viewController
        
        //when
        _ = viewController.view
        //then
        XCTAssertTrue(presenter.viewDidLoadDidCalled)
    }
}
