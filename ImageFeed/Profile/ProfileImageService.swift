import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let session = URLSession.shared
    private let baseURL = Constants.defaultBaseURL
    private let tokenStorage = OAuth2TokenStorage.shared
    private(set) var avatarURL: String?
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.fetchProfileImageURL(username: username, completion)
            }
            return
        }
        
        guard let token = tokenStorage.token else {
            completion(.failure(ServiceError.missingToken))
            return
        }
        
        guard let url = URL(string: "\(baseURL)/users/\(username)") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profileResult):
                if let avatarURL = profileResult.profileImage?.small {
                    self?.avatarURL = avatarURL
                    completion(.success(avatarURL))
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": avatarURL]
                        )
                }
            case .failure(let error):
                print("Error fetching profile image URL: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
