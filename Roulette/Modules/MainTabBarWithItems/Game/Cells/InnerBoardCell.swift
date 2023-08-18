//
//  InnerBoardCell.swift
//  Roulette
//
//  Created by Dmytro Hetman on 18.08.2023.
//

import UIKit

class InnerBoardCell: UICollectionViewCell {
    // UI elements
    private let numberLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Customize your cell appearance here
        contentView.backgroundColor = .white
        
        numberLabel.textAlignment = .center
        numberLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(numberLabel)
        
        // Set up constraints
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with slot: Slot) {
        numberLabel.text = "\(slot.number)"
        contentView.backgroundColor = slot.color
    }
}

