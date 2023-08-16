//
//  MainTabBarViewController.swift
//  Roulette
//
//  Created by Dmytro Hetman on 16.08.2023.
//

import UIKit
import FirebaseAuth

class MainTabBarViewController: UITabBarController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabBar()
        
//        try? Auth.auth().signOut()
    }
    
    private func setupTabBar() {
        let gameVC = UINavigationController(rootViewController: GameViewController())
        gameVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "gamecontroller"), selectedImage: UIImage(systemName: "gamecontroller.fill"))
        gameVC.tabBarItem.imageInsets = UIEdgeInsets(top: 16, left: 0, bottom: -16, right: 0)
        let ratingVC = UINavigationController(rootViewController: RatingViewController())
        ratingVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        ratingVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        settingsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        settingsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        viewControllers = [gameVC, ratingVC, settingsVC]
        tabBar.backgroundColor = .systemGray6
    }

    
}
