//
//  MainTabBarViewController.swift
//  Roulette
//
//  Created by Dmytro Hetman on 16.08.2023.
//

import UIKit
import FirebaseAuth

class MainTabBarViewController: UITabBarController {
    
    
    private var header: CustomHeaderBar?
    var model = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupHeaderView()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()
        
    }
    
    private func setupTabBar() {
        let game = GameViewController()
        game.model = model
        let gameVC = UINavigationController(rootViewController: game)
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
    
    private func setupHeaderView() {
        guard let userID = Auth.auth().currentUser?.uid
        else { return }
        let userInfo = model.getUserInfoBy(
          userID: userID,
          completion: { [weak self] nickname, chipsNum, rating in
              guard let self else { return }
              header?.nicknameLabel.text = nickname
              header?.quantityOfChipsLabel.text = "\(chipsNum)"
              header?.quantityOfChipsLabel.addImage(imageName: "coins_icon")
        })
        header = CustomHeaderBar(labelText: userInfo.0, quantityOfChips: userInfo.1)
        guard let header else { return }
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.widthAnchor.constraint(equalTo: view.widthAnchor),
            header.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    
}
