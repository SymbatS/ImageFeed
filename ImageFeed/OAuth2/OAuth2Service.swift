import UIKit

enum AuthServiceError: Error  {
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

    if task != nil {
               if lastCode != code {
                   task?.cancel()
               } else {
                   completion(.failure(AuthServiceError.invalidRequest))
                   return
               }
           } else {
               if lastCode == code {
                   completion(.failure(AuthServiceError.invalidRequest))
                   return
               }
           }
           lastCode = code
           guard
               let request = makeOAuthTokenRequest(code: code)
           else {
               completion(.failure(AuthServiceError.invalidRequest))
               return
           }

           let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
               DispatchQueue.main.async {
                   if let error = error {
                       print("Network error: \(error.localizedDescription)")
                       completion(.failure(error))
                       self?.task = nil
                       self?.lastCode = nil
                       return
                   }

                   guard let data = data else {
                       completion(.failure(AuthServiceError.invalidRequest))
                       self?.task = nil
                       self?.lastCode = nil
                       return
                   }

                   let storage = OAuth2TokenStorage()
                   do {
                       let responseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                       storage.token = responseBody.accessToken
                       completion(.success(responseBody.accessToken))
                   } catch {
                       print("Decoding error: \(error.localizedDescription)")
                       completion(.failure(error))
                   }
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
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}

