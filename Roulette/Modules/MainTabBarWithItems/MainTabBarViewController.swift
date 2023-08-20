//
//  MainTabBarViewController.swift
//  Roulette
//
//  Created by Dmytro Hetman on 16.08.2023.
//

import UIKit
import FirebaseAuth
import Firebase

class MainTabBarViewController: UITabBarController {
    
    private let aboveHeaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        return view
    }()
    
    private var header: CustomHeaderBar?
    private var authStateDidChangeHandle: AuthStateDidChangeListenerHandle?
    var databaseHandle: DatabaseHandle?

    var model = UserModel()
    let game = GameViewController()
    let rating = RatingViewController()
    let settings = SettingsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupHeaderView()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute:    { [weak self] in
            guard let self else { return }
            self.getUserInfo()
        })
        
        setupTabBar()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = model.ref.child("users").child(uid).child("quantityOfChips")
                
        databaseHandle = ref.observe(.value) { [weak self] snapshot in
            guard let self else { return }
            if let quantityOfChips = snapshot.value as? Int {
                self.header?.quantityOfChipsLabel.text = "\(quantityOfChips)"
                self.header?.quantityOfChipsLabel.addImage(imageName: "coins_icon")
            }
        }
    }
    
    private func presentLoginScreen() {
        let loginScreenVC = LoginScreenViewController()
        loginScreenVC.onDismiss = {
            self.getUserInfo()
            self.game.model = self.model
            
        }
        let loginNavigationController = UINavigationController(rootViewController: loginScreenVC)
        loginNavigationController.modalPresentationStyle = .fullScreen
        present(loginNavigationController, animated: false, completion: {
            self.game.headerPlaceholderView.heightAnchor.constraint(equalToConstant: 40).isActive = false
            self.game.headerPlaceholderView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        })
    }
    
    private func setupTabBar() {
        
        game.model = model
        let gameVC = UINavigationController(rootViewController: game)
        gameVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "gamecontroller"), selectedImage: UIImage(systemName: "gamecontroller.fill"))
        gameVC.tabBarItem.imageInsets = UIEdgeInsets(top: 16, left: 0, bottom: -16, right: 0)
        
        let ratingVC = UINavigationController(rootViewController: rating)
        ratingVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        ratingVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let settingsVC = UINavigationController(rootViewController: settings)
        settingsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        settingsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        viewControllers = [gameVC, ratingVC, settingsVC]
        tabBar.backgroundColor = .systemGray6
    }
    
    private func setupHeaderView() {
//        getUserInfo()
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
        print("get user info")
        print(userID)
        model.getUserInfoBy(
          userID: userID,
          completion: { [weak self] nickname, chipsNum, rating in
              guard let self else { return }
              header?.nicknameLabel.text = nickname
              header?.quantityOfChipsLabel.text = "\(chipsNum)"
              header?.quantityOfChipsLabel.addImage(imageName: "coins_icon")
              self.game.setBetView.setupStepper(by: chipsNum)
              self.model.currentUserNickname = nickname
              self.model.quantityOfChips = chipsNum
              print("after get info")
              print(nickname)
        })
        
    }
    
}
