import UIKit

final class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var isLoading = false
    private let networkService = NetworkService()
    
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
                            size: CGSize(width: photoResult.width, height: photoResult.height),
                            createdAt: ISO8601DateFormatter().date(from: photoResult.createdAt ?? ""),
                            welcomeDescription: photoResult.description,
                            thumbImageURL: photoResult.urls.thumb,
                            largeImageURL: photoResult.urls.full,
                            isLiked: photoResult.likedByUser
                        )
                    }
                    self.photos.append(contentsOf: newPhotos)
                    self.lastLoadedPage = nextPage
                    
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                case .failure(let error):
                    print("Failed to fetch photos: \(error)")
                }
            }
        }
    }
}
