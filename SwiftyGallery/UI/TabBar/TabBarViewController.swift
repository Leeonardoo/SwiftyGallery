//
//  ViewController.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 21/08/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
    }
    
    private func configureTabs() {
        let homeVc = UINavigationController(rootViewController: HomeViewController())
        homeVc.navigationBar.prefersLargeTitles = true
        homeVc.tabBarItem = UITabBarItem(title: "Home".localized,
                                         image: UIImage(systemName: "house.fill"),
                                         tag: 0)
        
        let favoritesVc = UINavigationController(rootViewController: FavoritesViewController())
        favoritesVc.navigationBar.prefersLargeTitles = true
        favoritesVc.tabBarItem = UITabBarItem(title: "Favorites".localized,
                                              image: UIImage(systemName: "star.fill"),
                                              tag: 1)
        
        let aboutVc = UINavigationController(rootViewController: AboutViewController())
        aboutVc.navigationBar.prefersLargeTitles = true
        aboutVc.tabBarItem = UITabBarItem(title: "About".localized,
                                          image: UIImage(systemName: "info.circle.fill"),
                                          tag: 2)
        
        viewControllers = [homeVc, favoritesVc, aboutVc]
    }
}
