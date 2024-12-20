import UIKit

protocol ProfileServiceProtocol {
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void)
    func clearData()
}

final class ProfileService: ProfileServiceProtocol {
    static let shared = ProfileService()
    
    private let session = URLSession.shared
    private let baseURL = Constants.defaultBaseURL
    private var task: URLSessionTask?
    private var lastToken: String?
    private let tokenStorage = OAuth2TokenStorage.shared
    private(set) var profile: Profile?
    
    private init() {}
    
    func clearData() {
        UserDefaults.standard.removeObject(forKey: "profileData")
    }
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.fetchProfile(completion: completion)
            }
            return
        }
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
