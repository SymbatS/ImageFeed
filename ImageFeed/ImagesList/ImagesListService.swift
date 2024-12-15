import UIKit
import Kingfisher

// MARK: - ImagesListService
final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var isLoading = false
    private let networkService = NetworkService.shared
    
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    private init() {}
    
    func clearImages() {
        UserDefaults.standard.removeObject(forKey: "imagesList")
    }
    
    func fetchPhotosNextPage() {
        guard !isLoading else { return }
        let nextPage = (lastLoadedPage ?? 0) + 1
        isLoading = true
        
        networkService.fetchPhotos(page: nextPage) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let photoResults):
                    let newPhotos = photoResults.map { photoResult in
                        Photo(
                            id: photoResult.id,
                            size: CGSize(width: photoResult.width ?? 1, height: photoResult.height ?? 1),
                            createdAt: ImagesListService.dateFormatter.date(from: photoResult.createdAt ?? ""),
                            welcomeDescription: photoResult.description,
                            thumbImageURL: photoResult.urls.thumb,
                            largeImageURL: photoResult.urls.full,
                            isLiked: photoResult.likedByUser
                        )
                    }
                    self.photos.append(contentsOf: newPhotos)
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: newPhotos)
                case .failure(let error):
                    print("Failed to fetch photos: \(error)")
                }
            }
        }
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = isLike ? "/photos/\(photoId)/like" : "/photos/\(photoId)/like"
        let method: String = isLike ? "POST" : "DELETE"
        let tokenStorage = OAuth2TokenStorage.shared
        var request = URLRequest(url: URL(string: "\(Constants.defaultBaseURL)\(endpoint)")!)
        request.httpMethod = method
        request.addValue("Bearer \(String(tokenStorage.token ?? ""))", forHTTPHeaderField: "Authorization")
        
        networkService.perform(request: request) { [weak self] result in
            switch result {
            case .success:
                if let index = self?.photos.firstIndex(where: { $0.id == photoId }) {
                    self?.photos[index].isLiked = isLike
                }
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updatePhotoLikeStatus(photoId: String, isLiked: Bool) {
        if let index = photos.firstIndex(where: { $0.id == photoId }) {
            photos[index].isLiked = isLiked
        }
    }
}
