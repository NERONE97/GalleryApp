//  GalleryViewController.swift

import UIKit

final class GalleryViewController: UIViewController {
    
    private let viewModel = GalleryViewModel()
    private let favouritesService = FavouritesService()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        viewModel.loadPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    private func setupUI() {
        title = "Галерея"
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 12
        let itemsPerRow: CGFloat = 3
        
        let totalSpacing = spacing * (itemsPerRow - 1)
        let availableWidth = UIScreen.main.bounds.width - 24 - totalSpacing
        let itemWidth = floor(availableWidth / itemsPerRow)
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(itemWidth * 1.2)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(itemWidth * 1.2)
        )
        // TO-DO: Фиксануть horizontal(layoutSize:subitem:count:)' was deprecated in iOS 16.0
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default))
        present(alert, animated: true)
    }
}

extension GalleryViewController: GalleryViewModelDelegate {
    
    func didLoadPhotos() {
        collectionView.reloadData()
    }
    
    func didFailLoading(with error: APIError) {
        showErrorAlert(message: "\(error)")
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Переиспользование
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GalleryCell.identifier,
            for: indexPath
        ) as? GalleryCell else {
            return UICollectionViewCell()
        }

        // Подстановка фото
        let photo = viewModel.photo(at: indexPath.item)
        let isFavourite = viewModel.isFavourite(at: indexPath.item)
        cell.configure(with: nil, isFavourite: isFavourite)
        
        // URL img c Model -> ImageLoader
        ImageLoader.shared.loadImage(from: photo.urls.thumb) { image in
            let isFavourite = self.viewModel.isFavourite(at: indexPath.item)
            cell.configure(with: image, isFavourite: isFavourite)
        }
        
        return cell
    }
}

extension GalleryViewController: UICollectionViewDelegate {
    // Пагинация
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.loadMorePhotosIfPossible(currentIndex: indexPath.item)
    }
    
    // Переход на Детали изображения
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel = ImageDetailViewModel(
            photosArray: viewModel.photos,
            initialIndex: indexPath.item,
            favouritesService: favouritesService
        )
        let viewController = ImageDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

#Preview {
    GalleryViewController()
}
