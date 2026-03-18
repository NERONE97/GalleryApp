//  ImageLoader.swift

import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private let cache: ImageCache
    private let session: URLSession
    
    private init(
        cache: ImageCache = .shared,
        session: URLSession = .shared
    ) {
        self.cache = cache
        self.session = session
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.image(forKey: urlString) {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] data, _, _ in
            guard let self,
                  let data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self.cache.setImage(image, forKey: urlString)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        task.resume()
    }
}
