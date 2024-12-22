import Foundation

protocol ImageListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class ImageListViewPresenter: ImageListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    private let imageListService = ImagesListService.shared
    
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangePhotos(_:)),
            name: ImagesListService.didChangeNotification,
            object: nil
        )
    }
    
    @objc private func didChangePhotos(_ notification: Notification) {
        view?.updateTableView()
    }
}
