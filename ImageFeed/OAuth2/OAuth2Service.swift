import UIKit

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if let existingTask = task {
            if lastCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            } else {
                existingTask.cancel()
            }
        }
        
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("Failed to create OAuth token request")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseBody):
                    let tokenStorage = OAuth2TokenStorage()
                    tokenStorage.token = responseBody.accessToken
                    completion(.success(responseBody.accessToken))
                    print("Token successfully retrieved: \(responseBody.accessToken)")
                case .failure(let error):
                    print("Error fetching OAuth token: \(error.localizedDescription)")
                    completion(.failure(error))
                }
                
                // Reset task and code after completion
                self?.task = nil
                self?.lastCode = nil
            }
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            print("Invalid base URL")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            print("Failed to create URL from components")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
