//  UnsplashEndpoint.swift

import Foundation

enum UnsplashEndpoint {
    
    static let baseURL = "https://api.unsplash.com"
    
    case photos(page: Int, perPage: Int)
    
    var url: URL? {
        switch self {
        case let .photos(page, perPage):
            var components = URLComponents(string: Self.baseURL + "/photos")
            components?.queryItems = [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(perPage)")
            ]
            return components?.url
        }
    }
}
