//  FavouritesViewModel.swift

import Foundation

struct FavouriteItem {
    let id: String
    let title: String
    let author: String
    let thumbURL: String
    let regularURL: String
}

final class FavouritesViewModel {
    
    private let favouritesService: FavouritesService
    private(set) var items: [FavouriteItem] = []
    
    init(favouritesService: FavouritesService = FavouritesService()) {
        self.favouritesService = favouritesService
    }
    
    func loadFavourites() {
        let favourites = favouritesService.fetchFavourites()
        
        items = favourites.map { FavouriteItem(
                id: $0.id ?? "",
                title: $0.photoDescription?.isEmpty == false ? ($0.photoDescription ?? "") : ($0.altDescription ?? "Неизвестное фото"),
                author: $0.authorName ?? "Неизвестный автор",
                thumbURL: $0.thumbUrl ?? "",
                regularURL: $0.regularUrl ?? ""
            )
        }
    }
    
    func removeFavourite(at index: Int) {
        let item = items[index]
        favouritesService.remove(photoId: item.id)
        items.remove(at: index)
    }
    
    func item(at index: Int) -> FavouriteItem {
        items[index]
    }
    
    var numberOfItems: Int {
        items.count
    }
}
