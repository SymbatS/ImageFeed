import Foundation

final class ImagesListServiceMock: ImagesListServiceProtocol {
    var photos: [Photo] = [
        Photo(
            id: "1",
            size: CGSize(width: 1024, height: 768),
            createdAt: Date(),
            welcomeDescription: "A sample photo",
            thumbImageURL: "url",
            largeImageURL: "url",
            isLiked: false
        )
    ]
    
    func fetchPhotosNextPage() {}
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {}
    func updatePhotoLikeStatus(photoId: String, isLiked: Bool) {}
}
