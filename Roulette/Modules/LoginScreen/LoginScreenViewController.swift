//
//  LoginScreenViewController.swift
//  Roulette
//
//  Created by Dmytro Hetman on 16.08.2023.
//

import UIKit
import FirebaseAuth

class LoginScreenViewController: UIViewController {
    
    private let enterNicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your nickname:"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let newNicknameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter here..."
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Roulette"
        label.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let getStartedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get started", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let model = RouletteModel()
    private var nicknameFromTextField = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonsLayer()
    }
    
    private func setup() {
        setupView()
    }
    
    
    
    
    
}
extension LoginScreenViewController {
    private func setupView() {
        setupGetStartedState()
        setupEnterNicknameState()
       
        self.enterNicknameLabel.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        self.newNicknameTextField.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        self.registerButton.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
    }
    
    private func setupGetStartedState() {
        setupMainLabel()
        setupGetStartedButton()
    }
    
    private func setupEnterNicknameState() {
        setupTextField()
        setupYourNicknameLabel()
        setupRegisterButton()
    }
    
    private func setupTextField() {
        view.addSubview(newNicknameTextField)
        NSLayoutConstraint.activate([
            newNicknameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newNicknameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            newNicknameTextField.heightAnchor.constraint(equalToConstant: 44),
            newNicknameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60)
        ])
        
        
    }

    private func setupMainLabel() {
        view.addSubview(mainLabel)
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainLabel.heightAnchor.constraint(equalToConstant: 44),
            mainLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupYourNicknameLabel() {
        
        view.addSubview(enterNicknameLabel)
        NSLayoutConstraint.activate([
            enterNicknameLabel.heightAnchor.constraint(equalToConstant: 40),
            enterNicknameLabel.centerYAnchor.constraint(equalTo: newNicknameTextField.centerYAnchor, constant: -36),
            enterNicknameLabel.leadingAnchor.constraint(equalTo: newNicknameTextField.leadingAnchor, constant: 8)
        ])
        
    }
    
    private func setupGetStartedButton() {
        getStartedButton.addTarget(self, action: #selector(getStarted), for: .touchUpInside)
        view.addSubview(getStartedButton)
        NSLayoutConstraint.activate([
            getStartedButton.heightAnchor.constraint(equalToConstant: 44),
            getStartedButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getStartedButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
        ])
    }
    
    private func setupRegisterButton() {
        registerButton.addTarget(self, action: #selector(loginAnonymously), for: .touchUpInside)
        view.addSubview(registerButton)
        NSLayoutConstraint.activate([
            registerButton.heightAnchor.constraint(equalToConstant: 44),
            registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: newNicknameTextField.bottomAnchor, constant: 32)
        ])
    }
    
    private func setupButtonsLayer() {
        getStartedButton.layer.cornerRadius = getStartedButton.frame.height / 4
        getStartedButton.backgroundColor = .white
        
        registerButton.layer.cornerRadius = getStartedButton.frame.height / 4
        registerButton.backgroundColor = .white
    }
}

extension LoginScreenViewController {
    @objc private func getStarted() {
        UIView.animate(withDuration: 0.5) {
            self.getStartedButton.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            self.mainLabel.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            self.enterNicknameLabel.transform = .identity
            self.newNicknameTextField.transform = .identity
            self.registerButton.transform = .identity
        } completion: { _ in
            self.getStartedButton.removeFromSuperview()
            self.mainLabel.removeFromSuperview()
        }
    }
    
    @objc private func loginAnonymously() {
        
        Auth.auth().signInAnonymously { authResult, error in
            if let authResult {
                let user = authResult.user
                let isAnonymous = user.isAnonymous  // true
                let uid = user.uid
                print(uid)
                if let user = Auth.auth().currentUser {
                    let authuid = user.uid
                    print("User with id \(authuid) is logged in")
                    self.model.registerNewUser(with: uid, nickname: self.nicknameFromTextField)
                    self.navigationController?.pushViewController(MainTabBarViewController(), animated: true)
                } else {
                    print("User with id \(uid) is NOT logged in")
                }
            }
        }
    }
}

extension LoginScreenViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        nicknameFromTextField = textField.text ?? ""
    }
}
