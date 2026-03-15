//  ImageDetailViewModel.swift

import Foundation

final class ImageDetailViewModel {
    
    private let photo: Photo
    private let favouritesService: FavouritesService
    
    init(photo: Photo, favouritesService: FavouritesService) {
        self.photo = photo
        self.favouritesService = favouritesService
    }
    
    var isFavourite: Bool {
           favouritesService.isFavourite(photoId: photo.id)
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
    
    func toggleFavourite() -> Bool {
            if isFavourite {
                favouritesService.remove(photoId: photo.id)
                return false
            } else {
                favouritesService.save(photo: photo)
                return true
            }
        }
}
