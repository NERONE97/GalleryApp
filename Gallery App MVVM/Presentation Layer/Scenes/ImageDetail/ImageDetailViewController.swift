//  ImageDetailViewController.swift

import UIKit

final class ImageDetailViewController: UIViewController {
    
    private let viewModel: ImageDetailViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    var favInSheetChanged: (() -> Void)?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIBarButtonItem = {
        UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(tapFavoriteButton)
        )
    }()
    
    init(viewModel: ImageDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        configureContent()
        loadImage()
        updateFavouriteButton()
        setupGestures()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Детали фото"
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [imageView, titleLabel, authorLabel].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.1),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupNavigation() {
        navigationItem.rightBarButtonItem = favoriteButton
        favoriteButton.tintColor = .red

        let isPresentedModally = presentingViewController != nil ||
            navigationController?.presentingViewController != nil

        if isPresentedModally {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .close,
                target: self,
                action: #selector(closeScreen)
            )
        }
    }
    
    private func configureContent() {
        titleLabel.text = viewModel.titleText
        authorLabel.text = viewModel.authorText
    }
    
    private func loadImage() {
        ImageLoader.shared.loadImage(from: viewModel.imageURL) { [weak self] image in
            DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            print("Подгрузкаююю")
        }
    }
    
    private func updateFavouriteButton() {
        let imageName = viewModel.isFavourite ? "heart.fill" : "heart"
        favoriteButton.image = UIImage(systemName: imageName)
        print("Избранное: \(viewModel.isFavourite)")
    }
    
    @objc
      private func tapFavoriteButton() {
          _ = viewModel.toggleFavourite()
          updateFavouriteButton()
          print("Кнопка <3 нажата")
          favInSheetChanged?()
      }
    
    @objc
    private func closeScreen() {
        dismiss(animated: true)
    }
    
    private func setupGestures() {
        view.isUserInteractionEnabled = true
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    private enum SwipeDirection {
        case left
        case right
    }
    
    @objc
    private func handleSwipeLeft() {
        guard viewModel.showNext() else { return }
        refreshContent(direction: .left)
    }

    @objc
    private func handleSwipeRight() {
        guard viewModel.showPrevious() else { return }
        refreshContent(direction: .right)
    }
    
    private func refreshContent(direction: SwipeDirection) {
        let outgoingOffset: CGFloat = direction == .left ? -120 : 120
        let incomingOffset: CGFloat = direction == .left ? 120 : -120
        
        let animatedViews: [UIView] = [imageView, titleLabel, authorLabel]
        
        UIView.animate(
            withDuration: 0.18,
            delay: 0,
            options: [.curveEaseIn],
            animations: {
                animatedViews.forEach { view in
                    view.transform = CGAffineTransform(translationX: outgoingOffset, y: 0)
                        .scaledBy(x: 0.92, y: 0.92)
                    view.alpha = 0
                }
            },
            completion: { _ in
                self.configureContent()
                self.updateFavouriteButton()
                
                self.imageView.image = nil
                self.loadImage()
                
                animatedViews.forEach { view in
                    view.transform = CGAffineTransform(translationX: incomingOffset, y: 0)
                        .scaledBy(x: 1.04, y: 1.04)
                }
                
                UIView.animate(
                    withDuration: 0.28,
                    delay: 0,
                    usingSpringWithDamping: 0.86,
                    initialSpringVelocity: 0.6,
                    options: [.curveEaseOut],
                    animations: {
                        animatedViews.forEach { view in
                            view.transform = .identity
                            view.alpha = 1
                        }
                    }
                )
            }
        )
    }
}

