//  Photo.swift

import Foundation

struct Photo: Codable {
    
    let id: String
    let description: String?
    let altDescription: String?
    
    let urls: PhotoURLs
    let user: PhotoUser?
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case altDescription = "alt_description"
        case urls
        case user
    }
}
