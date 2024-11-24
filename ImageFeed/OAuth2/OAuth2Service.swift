import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            print("Invalid base URL")
            return nil
        }
        
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            print("Invalid URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NSError(domain: "InvalidRequestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create request"])))
            return
        }
        
        let storage = OAuth2TokenStorage()
        
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .failure(let error):
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
                
            case .success(let data):
                do {
                    let responseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    storage.token = responseBody.accessToken
                    completion(.success(responseBody.accessToken))
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
