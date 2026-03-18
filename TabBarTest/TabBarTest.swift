//
//  TabBarTest.swift
//  TabBarTest
//
//  Created by Roman on 18.03.26.
//

import XCTest
@testable import Gallery_App_MVVM

final class TabBarControllerTests: XCTestCase {

    func testTabBarControllerSetsUpTwoTabs() {
        
        let sut = TabBarController()

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.viewControllers?.count, 2)

        let firstNav = sut.viewControllers?[0] as? UINavigationController
        let secondNav = sut.viewControllers?[1] as? UINavigationController

        XCTAssertEqual(firstNav?.tabBarItem.title, "Галерея")
        XCTAssertEqual(secondNav?.tabBarItem.title, "Избранное")

        XCTAssertTrue(firstNav?.topViewController is GalleryViewController)
        XCTAssertTrue(secondNav?.topViewController is FavouritesViewController)
    }
}
