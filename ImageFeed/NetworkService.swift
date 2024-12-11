import Foundation

final class NetworkService {
    func fetchPhotos(page: Int, completion: @escaping (Result<[PhotoResult], Error>) -> Void) {
        let url = URL(string: "https://api.unsplash.com/photos?page=\(page)&client_id=YOUR_ACCESS_KEY")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let photoResults = try JSONDecoder().decode([PhotoResult].self, from: data)
                completion(.success(photoResults))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
