//  APIError.swift

import Foundation

enum APIError: Error {
    
    case invalidURL
    case invalidResponse
    case decodingFailed
    case network(Error)
    case unknown
}
