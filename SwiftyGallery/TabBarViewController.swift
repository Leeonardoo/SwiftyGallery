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
        let homeVc = UINavigationController(rootViewController: UIViewController())
        homeVc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let favoritesVc = UINavigationController(rootViewController: UIViewController())
        favoritesVc.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)
        
        let aboutVc = UINavigationController(rootViewController: UIViewController())
        aboutVc.tabBarItem = UITabBarItem(title: "About", image: UIImage(systemName: "info.circle.fill"), tag: 2)
        
        viewControllers = [homeVc, favoritesVc, aboutVc]
    }
}
