//  GalleryCell.swift

import UIKit

final class GalleryCell: UICollectionViewCell {
    
    static let identifier = "GalleryCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let favouriteIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .red
        imageView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8)
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init error")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        favouriteIconView.isHidden = true
    }
    // plchld -> real img
    func configure(with image: UIImage?, isFavourite: Bool) {
        imageView.image = image
        favouriteIconView.isHidden = !isFavourite
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(favouriteIconView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        favouriteIconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            favouriteIconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favouriteIconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            favouriteIconView.widthAnchor.constraint(equalToConstant: 30),
            favouriteIconView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
