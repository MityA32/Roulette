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
        button.backgroundColor = .white
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    private let existingAccountLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You have existing account on this device"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    
    private var nicknameFromTextField = ""
    private var hasExistingAccount = false
    
    var onDismiss: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerButton.isUserInteractionEnabled = true
        loginButton.isUserInteractionEnabled = true
        UserModel.checkDeviceIDExists(deviceID: UserModel.deviceID(), completion: { [weak self] exists in
            guard let self else { return }
            self.hasExistingAccount = exists
            exists ? self.setupLoginState() : self.setupEnterNicknameState()
        })
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
        view.backgroundColor = .black
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupGetStartedState()
        print(UserModel.deviceID())
        
    }
    
    private func setupGetStartedState() {
        setupMainLabel()
        setupGetStartedButton()
    }
    
    private func setupEnterNicknameState() {
        self.enterNicknameLabel.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        self.newNicknameTextField.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        self.registerButton.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        setupTextField()
        setupYourNicknameLabel()
        setupAuth(button: registerButton, of: .register)
    }
    
    private func setupLoginState() {
        self.existingAccountLabel.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        self.loginButton.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        setupExistingAccountLabel()
        setupAuth(button: loginButton, of: .login)
        
        
    }
    
    private func setupTextField() {
        newNicknameTextField.delegate = self
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
    
    private func setupExistingAccountLabel() {
        view.addSubview(existingAccountLabel)
        
        NSLayoutConstraint.activate([
            existingAccountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            existingAccountLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            existingAccountLabel.heightAnchor.constraint(equalToConstant: 80),
            existingAccountLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    
    private func setupAuth(button: UIButton, of type: AuthButtonType) {
        button.isUserInteractionEnabled = true
        switch type {
        case .register:
            button.addTarget(self, action: #selector(registerAnonymously), for: .touchUpInside)
        case .login:
            button.addTarget(self, action: #selector(loginAnonymously), for: .touchUpInside)
        }
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        switch type {
        case .register:
            button.topAnchor.constraint(equalTo: newNicknameTextField.bottomAnchor, constant: 32).isActive = true
        case .login:
            button.topAnchor.constraint(equalTo: existingAccountLabel.bottomAnchor, constant: 32).isActive = true
        }
    }
    
    private func setupButtonsLayer() {
        getStartedButton.layer.cornerRadius = getStartedButton.frame.height / 4
        getStartedButton.backgroundColor = .white
        
        registerButton.layer.cornerRadius = getStartedButton.frame.height / 4
        registerButton.backgroundColor = .white
        
        loginButton.layer.cornerRadius = getStartedButton.frame.height / 4
        loginButton.backgroundColor = .white
    }
}

extension LoginScreenViewController {
    @objc private func getStarted() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }
            self.getStartedButton.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            self.mainLabel.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
//            if self.hasExistingAccount {
                self.existingAccountLabel.transform = .identity
                self.loginButton.transform = .identity
                
//            } else {
                self.enterNicknameLabel.transform = .identity
                self.newNicknameTextField.transform = .identity
                self.registerButton.transform = .identity
//            }
            
        } completion: { _ in
            self.getStartedButton.removeFromSuperview()
            self.mainLabel.removeFromSuperview()
        }
    }
    
    @objc private func registerAnonymously() {
        registerButton.isUserInteractionEnabled = false
        if self.nicknameFromTextField.isEmpty || self.nicknameFromTextField.replacingOccurrences(of: " ", with: "").isEmpty {
            let alertController = UIAlertController(title: "Alert", message: "Nickname cannot be empty!", preferredStyle: .alert)
                    
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
            return
        }
        Auth.auth().signInAnonymously { authResult, error in
            if let authResult {
                let user = authResult.user
                let isAnonymous = user.isAnonymous  // true
                let uid = user.uid
                print(uid)
                if let user = Auth.auth().currentUser {
                    let authuid = user.uid
                    print("User with id \(authuid) is logged in")
                    
                    UserModel.registerNewUser(with: uid, nickname: self.nicknameFromTextField.trimmingCharacters(in: .whitespaces)) { _ in }
                    self.dismiss(animated: true) {
                        guard let onDismiss = self.onDismiss else { return }
                        onDismiss()
                    }

                } else {
                    print("User with id \(uid) is NOT logged in")
                }
            }
        }
    }
    
    @objc private func loginAnonymously() {
        // Disable the button interaction to prevent multiple taps
        loginButton.isUserInteractionEnabled = false
        
        // Sign in anonymously
        Auth.auth().signInAnonymously { [weak self] authResult, error in
            guard let self = self, let authResult = authResult else {
                // Handle error and re-enable button interaction if needed
                self?.loginButton.isUserInteractionEnabled = true
                return
            }
            
            let user = authResult.user
            let uid = user.uid
            print("Logged in with UID: \(uid)")
            
            // Now you have a signed-in user, you can proceed with further operations
            self.loginToExistingAccount(uid: uid)
            
            // Re-enable the button interaction
            self.loginButton.isUserInteractionEnabled = true
        }
    }

    private func loginToExistingAccount(uid: String) {
        UserModel.loginByExisting(deviceID: UserModel.deviceID(), completion: { [weak self] userDict, loggedIn in
            guard let self = self, loggedIn else {
                // Handle failed login if needed
                return
            }
            
            // Extract user data from userDict
            if let name = userDict["nickname"] as? String,
               let quantityOfChips = userDict["quantityOfChips"] as? Int,
               let rating = userDict["rating"] as? Int {
                
                // Register user if needed
                UserModel.registerNewUser(
                    with: uid,
                    nickname: name,
                    quantityOfChips: quantityOfChips,
                    rating: rating
                ) { _ in
                    // Handle completion if needed
                }
                
                // Navigate to the next screen
                self.dismiss(animated: true) {
                    guard let onDismiss = self.onDismiss else { return }
                    onDismiss()
                }
            }
        })
    }



    
}

extension LoginScreenViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        nicknameFromTextField = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
