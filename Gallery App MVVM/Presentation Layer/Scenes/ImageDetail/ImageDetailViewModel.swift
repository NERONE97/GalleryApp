//  ImageDetailViewModel.swift

import Foundation

final class ImageDetailViewModel {
    
    private let photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    var imageURL: String {
        photo.urls.regular
    }
    
    var titleText: String {
        if let description = photo.description, !description.isEmpty {
            return description
        }
        
        if let altDescription = photo.altDescription, !altDescription.isEmpty {
            return altDescription
        }
        
        return "Неизвестное фото"
    }
    
    var authorText: String {
        guard let user = photo.user else {
            return "Неизвестный автор"
        }
        
        return user.name
    }
}
