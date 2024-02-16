//
//  ViewController.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 21/08/23.
//

import UIKit

#if DEBUG
import SwiftUI
import PulseUI
#endif

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        configureTabs()
    }
    
#if DEBUG
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let controller = UIHostingController(rootView: PulseUIView())
            
            controller.modalPresentationStyle = .pageSheet
            
            self.present(controller, animated: true)
        }
    }
#endif
    
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
        
        viewControllers = [homeVc, favoritesVc]
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    
    /// We want to handle the re-selection of a tab that either goes back to the root
    /// ViewController or scrolls to the top when it's already at the root ViewController.
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // The ViewControllers are wrapped in another UINavigationController,
        // so we need to check if there's only one on the stack and if it conforms
        // to the TabBarReselectHandler protocol.
        if tabBarController.selectedViewController == viewController,
           let navigationController = viewController as? UINavigationController,
           navigationController.viewControllers.count == 1,
           let handler = navigationController.viewControllers.first as? TabBarReselectHandler {
            handler.didReselectTab()
        }
        
        return true
    }
}
