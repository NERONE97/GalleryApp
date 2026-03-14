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
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func loadPhotos() {
        apiService.fetchPhotos(page: 1, perPage: 30) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case let .success(photos):
                    self.photos = photos
                    self.delegate?.didLoadPhotos()
                    
                case let .failure(error):
                    self.delegate?.didFailLoading(with: error)
                }
            }
        }
    }
    
    func photo(at index: Int) -> Photo {
        photos[index]
    }
    
    var numberOfItems: Int {
        photos.count
    }
}
