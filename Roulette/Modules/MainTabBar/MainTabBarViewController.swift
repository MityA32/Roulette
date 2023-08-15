//
//  MainTabBarViewController.swift
//  Roulette
//
//  Created by Dmytro Hetman on 16.08.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        
        
    }
    
    private func setupTabBar() {
        let gameVC = UINavigationController(rootViewController: GameViewController())
        gameVC.tabBarItem = UITabBarItem(title: Tabs.game.title, image: UIImage(systemName: "gamecontroller"), selectedImage: UIImage(systemName: "gamecontroller.fill"))
        let ratingVC = UINavigationController(rootViewController: RatingViewController())
        ratingVC.tabBarItem = UITabBarItem(title: Tabs.rating.title, image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        settingsVC.tabBarItem = UITabBarItem(title: Tabs.settings.title, image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        
        viewControllers = [gameVC, ratingVC, settingsVC]
    }

    
}
