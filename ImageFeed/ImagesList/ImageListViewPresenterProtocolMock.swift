import Foundation

final class ImageListViewPresenterProtocolMock: ImageListViewPresenterProtocol {
    var view: (any ImagesListViewControllerProtocol)?
    var viewDidLoadCalled = false
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}
