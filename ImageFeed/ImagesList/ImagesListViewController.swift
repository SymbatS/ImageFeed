import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImageListViewPresenterProtocol? { get set }
    func updateTableView()
}

// MARK: - ImagesListViewController
final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    var presenter: ImageListViewPresenterProtocol?
    @IBOutlet var tableView: UITableView!
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    var service: ImagesListServiceProtocol = ImagesListService.shared
    private var shouldDisablePagination: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shouldDisablePagination = CommandLine.arguments.contains("--disable-pagination")
        setupTableView()
        presenter?.viewDidLoad()
        service.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier,
           let viewController = segue.destination as? SingleImageViewController,
           let indexPath = sender as? IndexPath {
            let photo = service.photos[indexPath.row]
            guard let url = URL(string: photo.largeImageURL) else { return }
            viewController.imageURL = url
        }
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            let oldCount = self.tableView.numberOfRows(inSection: 0)
            let newCount = self.service.photos.count
            
            guard newCount > oldCount else { return }
            
            let newIndexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            self.tableView.performBatchUpdates {
                self.tableView.insertRows(at: newIndexPaths, with: .automatic)
            }
        }
    }
    
    private func fetchData(page: Int) {
        if shouldDisablePagination && page > 1 {
            return
        }
        service.fetchPhotosNextPage()
        print("Fetching data for page \(page)")
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.accessibilityIdentifier = "table View"
    }
    
    private func toggleLike(for indexPath: IndexPath) {
        let photo = service.photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        service.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            DispatchQueue.main.async {
                
                UIBlockingProgressHUD.dismiss()
                
                switch result {
                case .success:
                    self?.service.updatePhotoLikeStatus(photoId: photo.id, isLiked: !photo.isLiked)
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    self?.showErrorAlert()
                    print("Failed to toggle like: \(error)")
                }
            }
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        service.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        let photo = service.photos[indexPath.row]
        let date = photo.createdAt.map { DateFormatter.localizedDateFormatter.string(from: $0) } ?? "Unknown date"
        
        cell.configure(
            imageURL: URL(string: photo.thumbImageURL),
            date: date,
            isLiked: photo.isLiked
        ) { [weak self] in
            guard let self = self else { return }
            self.toggleLike(for: indexPath)
        }
        
        cell.onLikeButtonTapped = { [weak self] in
            self?.toggleLike(for: indexPath)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if shouldDisablePagination { return }
        
        if indexPath.row == service.photos.count - 1 {
            service.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}
