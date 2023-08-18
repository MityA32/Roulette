//
//  UIView+Extension.swift
//  Roulette
//
//  Created by Dmytro Hetman on 18.08.2023.
//

import UIKit

extension UIView {
    func setBet(value: String) {
        let titleLabel = UILabel()
        titleLabel.text = value
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        
        titleLabel.textAlignment = .center
        titleLabel.frame = bounds
        addSubview(titleLabel)

    }
}
