//  APIService.swift
// https://unsplash.com/oauth/applications/892912 - Access Key

import Foundation

final class APIService: APIServiceProtocol {
    
    private let session: URLSession
    private let accessKey = "yfUsKSm2xhiWSU7ZyvbqVIpIiMPPX-EkuaiyvvIHwzs"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchPhotos(page: Int, perPage: Int, completion: @escaping (Result<[Photo], APIError>) -> Void) {
        guard let url = UnsplashEndpoint.photos(page: page, perPage: perPage).url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(.network(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200 ... 299 ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data else {
                completion(.failure(.unknown))
                return
            }
            
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                completion(.success(photos))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }
        
        task.resume()
    }
}
