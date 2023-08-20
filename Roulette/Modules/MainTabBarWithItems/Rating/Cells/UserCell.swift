//
//  UserCell.swift
//  Roulette
//
//  Created by Dmytro Hetman on 18.08.2023.
//

import UIKit

class UserCell: UITableViewCell {
    
    let profileImage = UIImageView()
    let nicknameLabel = UILabel()
    let quantityOfChipsLabel = UILabel()
    let winRateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        contentView.layer.cornerRadius = 10
        contentView.layer.backgroundColor = UIColor.systemGray3.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.image = UIImage(systemName: "person.circle")
        contentView.addSubview(profileImage)
        
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        contentView.addSubview(nicknameLabel)
        
        quantityOfChipsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(quantityOfChipsLabel)
        
        winRateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(winRateLabel)
        
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .clear
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
           profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
           profileImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
           profileImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
           profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor),
           
           nicknameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 20),
           nicknameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
           
           winRateLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
           winRateLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 4),
           
           quantityOfChipsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
           quantityOfChipsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
           quantityOfChipsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
           
           separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
           separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
           separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
           separatorView.heightAnchor.constraint(equalToConstant: 8)
       ])
    }
    
    func configure(with user: User) {
        profileImage.image = UIImage(systemName: "person.circle")
        nicknameLabel.text = user.nickname
        quantityOfChipsLabel.text = "\(user.quantityOfChips)"
        winRateLabel.text = "Win Rate: \(Double(round(100 * user.winRate * 100) / 100))%"
    }
}

