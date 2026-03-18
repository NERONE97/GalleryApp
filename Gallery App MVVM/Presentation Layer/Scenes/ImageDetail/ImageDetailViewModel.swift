//  ImageDetailViewModel.swift

import Foundation

final class ImageDetailViewModel {
    
    private let photosArray: [Photo]
    private let favouritesService: FavouritesService
    private var currentIndex: Int
    
    init(photosArray: [Photo], initialIndex: Int, favouritesService: FavouritesService) {
        self.photosArray = photosArray
        self.currentIndex = initialIndex
        self.favouritesService = favouritesService
    }
// Блок свайпов
    private var currentPhoto: Photo {
          photosArray[currentIndex]
      }
    
    var canShowPrevious: Bool {
        currentIndex > 0
    }
    
    var canShowNext: Bool {
        currentIndex < photosArray.count - 1
    }

    var isFavourite: Bool {
           favouritesService.isFavourite(photoId: currentPhoto.id)
       }
    
    var imageURL: String {
        currentPhoto.urls.regular
    }
    
    var titleText: String {
        if let description = currentPhoto.description, !description.isEmpty {
            return description
        }
        
        if let altDescription = currentPhoto.altDescription, !altDescription.isEmpty {
            return altDescription
        }
        
        return "Неизвестное фото"
    }
    
    var authorText: String {
        guard let user = currentPhoto.user else {
            return "Неизвестный автор"
        }
        
        return user.name
    }
    
    func toggleFavourite() -> Bool {
            if isFavourite {
                favouritesService.remove(photoId: currentPhoto.id)
                return false
            } else {
                favouritesService.save(photo: currentPhoto)
                return true
            }
        }
    
    func showNext() -> Bool {
        guard canShowNext else { return false }
        currentIndex += 1
        return true
    }
    
    func showPrevious() -> Bool {
        guard canShowPrevious else { return false }
        currentIndex -= 1
        return true
    }
}
