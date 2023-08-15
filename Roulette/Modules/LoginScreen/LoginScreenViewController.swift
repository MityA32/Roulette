//
//  LoginScreenViewController.swift
//  Roulette
//
//  Created by Dmytro Hetman on 16.08.2023.
//

import UIKit
import FirebaseAuth

class LoginScreenViewController: UIViewController {
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLoginButtonLayer()
    }
    
    private func setup() {
        setupView()
    }
    
    private func setupView() {
        setupLoginButton()
        setupLabels()
    }

    private func setupLabels() {
        
        
        
    }
    
    private func setupLoginButton() {
        loginButton.addTarget(self, action: #selector(loginAnonymously), for: .touchUpInside)
        
        
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -64)
        ])
    }
    
    private func setupLoginButtonLayer() {
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.backgroundColor = .blue
    }
    
    @objc private func loginAnonymously() {
        Auth.auth().signInAnonymously { authResult, error in
            if let authResult {
                
                let user = authResult.user
                let isAnonymous = user.isAnonymous  // true
                let uid = user.uid
                print("User with id \(uid) is logged in")
                self.navigationController?.pushViewController(MainTabBarViewController(), animated: true)
            }
        }
    }
    
}
