//  FavouritesViewController.swift

import UIKit

final class FavouritesViewController: UIViewController {
    
    private let viewModel = FavouritesViewModel()
    private let favouritesService = FavouritesService()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет избранных изображений"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavourites()
        updateUI()
    }
    
    private func setupUI() {
        title = "Избранное"
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            emptyStateLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func updateUI() {
        let isEmpty = viewModel.numberOfItems == 0
        emptyStateLabel.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
        collectionView.reloadData()
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
}

extension FavouritesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell( withReuseIdentifier: GalleryCell.identifier,for: indexPath) as? GalleryCell else { return UICollectionViewCell()
        }

        let item = viewModel.item(at: indexPath.item)
        cell.configure(with: nil, isFavourite: true)

        ImageLoader.shared.loadImage(from: item.thumbURL) { [weak collectionView] image in
            DispatchQueue.main.async {
                guard
                    let currentCell = collectionView?.cellForItem(at: indexPath) as? GalleryCell
                else { return }

                currentCell.configure(with: image, isFavourite: true)
            }
        }

        return cell
    }
}

extension FavouritesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewModel = ImageDetailViewModel(
            photosArray: viewModel.photos,
            initialIndex: indexPath.item,
            favouritesService: favouritesService
        )
        
        

        let viewController = ImageDetailViewController(viewModel: detailViewModel)
        viewController.favInSheetChanged = { [weak self] in
            self?.viewModel.loadFavourites()
            self?.updateUI()
        }

        navigationController?.pushViewController(viewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let delete = UIAction(
                title: "Удалить из избранного",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                guard let self else { return }
                self.viewModel.removeFavourite(at: indexPath.item)
                self.updateUI()
            }

            return UIMenu(title: "", children: [delete])
        }
    }
}

