//
//  SettingsOptionTableViewCell.swift
//  Roulette
//
//  Created by Dmytro Hetman on 17.08.2023.
//

import UIKit
import FirebaseAuth
import StoreKit

class SettingsOptionTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "SettingsOptionTableViewCell"
    private let button = UIButton()
    
    var type: SettingsOptionsType?
    weak var delegate: SettingsViewController?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    func configure(from type: SettingsOptionsType) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(type.title, for: .normal)
        button.backgroundColor = type.buttonColor
        button.layer.cornerRadius = 10
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        switch type {
            case .logOut:
                button.addTarget(self, action: #selector(logout), for: .touchUpInside)
            case .deleteAccount:
                button.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
            case .rateApp:
                button.addTarget(self, action: #selector(rateApp), for: .touchUpInside)
            case .shareApp:
                button.addTarget(self, action: #selector(shareApp), for: .touchUpInside)
        }
    }
    
    @objc
    private func logout() {
        try? Auth.auth().signOut()
    }
    
    @objc
    private func deleteAccount() {
        
    }
    
    @objc
    private func rateApp() {
        SKStoreReviewController.requestReview()
    }
    
    @objc
    private func shareApp() {
        guard let url = URL(string: "https://www.apple.com") else { return }
        let items = [url]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        delegate?.present(ac, animated: true)
    }
    
}
