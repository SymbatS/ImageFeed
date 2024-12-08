import UIKit

final class ProfileService {
    static let shared = ProfileService()
    
    private let session = URLSession.shared
    private let baseURL = Constants.defaultBaseURL
    private var task: URLSessionTask?
    private var lastToken: String?
    private let tokenStorage = OAuth2TokenStorage()
    private(set) var profile: Profile?
    
    private init() {}
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let token = tokenStorage.token else {
            completion(.failure(ServiceError.missingToken))
            return
        }
        
        if task != nil {
            if lastToken != token {
                task?.cancel()
            } else {
                completion(.failure(ServiceError.invalidURL))
                return
            }
        } else {
            if lastToken == token {
                completion(.failure(ServiceError.invalidURL))
                return
            }
        }
        lastToken = token
        
        guard let url = URL(string: "\(baseURL)/me")
        else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        let request = URLRequest.makeRequest(url: url, token: token)
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileResult):
                    let profile = Profile(from: profileResult)
                    self?.profile = profile
                    completion(.success(profile))
                case .failure(let error):
                    print("Error fetching profile: \(error)")
                }
                self?.resetTask()
            }
        }
        self.task = task
        task.resume()
    }
    
    private func resetTask() {
        self.task = nil
        self.lastToken = nil
    }
}

enum ServiceError: Error {
    case invalidURL
    case noData
    case missingToken
}

struct ProfileResult: Codable {
    let id: String
    let username: String
    let name: String?
    let bio: String?
    let location: String?
    let totalLikes: Int?
    let totalPhotos: Int?
    let profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case bio
        case location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(from profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = "\(profileResult.name ?? "")"
        self.loginName = "@\(profileResult.username)"
        self.bio = profileResult.bio
    }
}

extension URLRequest {
    static func makeRequest(
        url: URL,
        token: String
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
