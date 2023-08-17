//
//  MainTabBarViewController.swift
//  Roulette
//
//  Created by Dmytro Hetman on 16.08.2023.
//

import UIKit
import FirebaseAuth

class MainTabBarViewController: UITabBarController {
    
    private let aboveHeaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        return view
    }()
    
    private var header: CustomHeaderBar?
    private var authStateDidChangeHandle: AuthStateDidChangeListenerHandle?

    var model = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        authStateDidChangeHandle = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            guard let self = self else { return }
            if user == nil {
                DispatchQueue.main.async {
                    self.presentLoginScreen()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.selectedIndex = 0
                    })
                    
                }
            }
        }
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.presentLoginScreen()
            }
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupHeaderView()
        setupTabBar()
        
    }
    
    private func presentLoginScreen() {
        let loginScreenVC = LoginScreenViewController()
        loginScreenVC.onDismiss = {
            self.getUserInfo()
        }
        let loginNavigationController = UINavigationController(rootViewController: loginScreenVC)
        loginNavigationController.modalPresentationStyle = .fullScreen
        present(loginNavigationController, animated: false, completion: nil)
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
        getUserInfo()
        
        header = CustomHeaderBar(labelText: "***", quantityOfChips: "*")
        guard let header else { return }
        view.addSubview(header)
        view.addSubview(aboveHeaderView)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.widthAnchor.constraint(equalTo: view.widthAnchor),
            header.heightAnchor.constraint(equalToConstant: 44),
            
            aboveHeaderView.topAnchor.constraint(equalTo: view.topAnchor),
            aboveHeaderView.bottomAnchor.constraint(equalTo: header.topAnchor),
            aboveHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            aboveHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func getUserInfo() {
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
        print(userInfo)
    }
    
}
