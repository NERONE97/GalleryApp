//
//  TabBarController.swift
//  

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let galleryViewController = GalleryViewController()
        let galleryNavController = UINavigationController(rootViewController: galleryViewController)
        galleryNavController.tabBarItem.title = "Галерея"
        galleryNavController.tabBarItem.image = UIImage(systemName: "photo.on.rectangle")

        let favouritesViewController = FavouritesViewController()
        let favouritesNavController = UINavigationController(rootViewController: favouritesViewController)
        favouritesNavController.tabBarItem.title = "Избранное"
        favouritesNavController.tabBarItem.image = UIImage(systemName: "heart.fill")

        viewControllers = [galleryNavController, favouritesNavController]
    }
}
