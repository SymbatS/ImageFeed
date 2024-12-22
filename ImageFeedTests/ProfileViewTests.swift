@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
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
    
    func testDidTapLogout() {
        //given
        let presenter = ProfileViewPresenter(profileService: ProfileServiceSpy(), profileImageService: ProfileImageServiceSpy())
        let viewController = ProfileViewController(presenter: presenter)
        presenter.view = viewController
        viewController.presenter = presenter
        //when
        presenter.didTapLogout()
        //then
        XCTAssertTrue(presenter.viewDidTapLogout)
    }
}
