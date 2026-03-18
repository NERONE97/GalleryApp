//  GalleryViewModel.swift

import Foundation

protocol GalleryViewModelDelegate: AnyObject {
    func didLoadPhotos()
    func didFailLoading(with error: APIError)
}

final class GalleryViewModel {
    
    weak var delegate: GalleryViewModelDelegate?
    
    private let apiService: APIServiceProtocol
    private(set) var photos: [Photo] = []
    private let favouritesService: FavouritesService
    
    private var currentPage = 1
    private let perPage = 30
    private var isLoading = false
    private var hasMorePages = true
    
    init(apiService: APIServiceProtocol = APIService(), favouritesService: FavouritesService = FavouritesService()) {
        self.apiService = apiService
        self.favouritesService = favouritesService
    }
    
    func loadPhotos() {
        
        guard !isLoading else { return }
        isLoading = true
        
        apiService.fetchPhotos(page: currentPage, perPage: perPage) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                    case let .success(newPhotos):
                        if newPhotos.count < self.perPage {
                            self.hasMorePages = false
                        }
                        
                        self.photos.append(contentsOf: newPhotos)
                        self.delegate?.didLoadPhotos()
                        
                    case let .failure(error):
                        self.delegate?.didFailLoading(with: error)
                }
            }
        }
    }
    
    func loadMorePhotosIfPossible(currentIndex: Int) {
        // Зазор
        let indexOfScreenEnding = photos.count - 10
        
        guard currentIndex >= indexOfScreenEnding,!isLoading, hasMorePages else { return }
        currentPage += 1
        loadPhotos()
    }
    
    func photo(at index: Int) -> Photo {
        photos[index]
    }
    
    var numberOfItems: Int {
        photos.count
    }
    
    func isFavourite(at index: Int) -> Bool {
         let photo = photos[index]
         return favouritesService.isFavourite(photoId: photo.id)
     }
}
