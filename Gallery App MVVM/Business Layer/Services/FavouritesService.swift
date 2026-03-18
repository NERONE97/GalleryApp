//  FavouritesService.swift

import CoreData
import Foundation

final class FavouritesService {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    func save(photo: Photo) {
        guard !isFavourite(photoId: photo.id) else { return }
        
        let entity = FavouritePhoto(context: context)
        
        entity.id = photo.id
        entity.photoDescription = photo.description
        entity.altDescription = photo.altDescription
        entity.thumbUrl = photo.urls.thumb
        entity.regularUrl = photo.urls.regular
        entity.authorName = photo.user?.name
        
        CoreDataManager.shared.saveContext()
    }
    
    func remove(photoId: String) {
        let request: NSFetchRequest<FavouritePhoto> = FavouritePhoto.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", photoId)
        
        if let result = try? context.fetch(request).first {
            context.delete(result)
            CoreDataManager.shared.saveContext()
        }
    }
    
    func isFavourite(photoId: String) -> Bool {
        let request: NSFetchRequest<FavouritePhoto> = FavouritePhoto.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", photoId)
        
        let count = (try? context.count(for: request)) ?? 0
        return count > 0
    }

    
    func fetchFavourites() -> [FavouritePhoto] {
        let request: NSFetchRequest<FavouritePhoto> = FavouritePhoto.fetchRequest()
        
        return (try? context.fetch(request)) ?? []
    }
}

