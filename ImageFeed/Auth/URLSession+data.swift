import UIKit

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidURL
    case noData
    case decodingError(Error)
    case httpError(Int)
    case invalidResponse
}

extension URLSession {
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        let task = data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedObject = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decodedObject))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                        print("Ошибка декодирования")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                    print("Ошибка выполнения запроса")
                }
            }
        }
        return task
    }
    
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка запроса: \(error.localizedDescription)")
                fulfillCompletionOnMainThread(.failure(NetworkError.urlRequestError(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Ошибка сессии: отсутствует HTTP-ответ")
                fulfillCompletionOnMainThread(.failure(NetworkError.urlSessionError))
                return
            }
            
            guard 200..<300 ~= response.statusCode else {
                print("HTTP ошибка: код состояния \(response.statusCode)")
                fulfillCompletionOnMainThread(.failure(NetworkError.httpStatusCode(response.statusCode)))
                return
            }
            
            guard let data = data else {
                print("Ошибка: отсутствуют данные")
                fulfillCompletionOnMainThread(.failure(NetworkError.urlSessionError))
                return
            }
            
            fulfillCompletionOnMainThread(.success(data))
        }
        
        return task
    }
}
