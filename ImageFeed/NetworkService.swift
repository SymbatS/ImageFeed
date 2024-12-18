import Foundation

final class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchPhotos(page: Int, completion: @escaping (Result<[PhotoResult], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.defaultBaseURL)/photos?page=\(page)&client_id=\(Constants.accessKey)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                completion(.failure(NetworkError.httpError(statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let photoResults = try JSONDecoder().decode([PhotoResult].self, from: data)
                completion(.success(photoResults))
            } catch {
                completion(.failure(NetworkError.decodingError(error)))
            }
        }.resume()
    }
    func perform(request: URLRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            completion(.success(()))
        }
        task.resume()
    }
}

