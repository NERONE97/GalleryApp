//  APIServiceProtocol.swift

import Foundation

protocol APIServiceProtocol {
    func fetchPhotos(page: Int, perPage: Int, completion: @escaping (Result<[Photo], APIError>) -> Void)
}
