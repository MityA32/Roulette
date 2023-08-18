//
//  UIButton+Extension.swift
//  Roulette
//
//  Created by Dmytro Hetman on 18.08.2023.
//

import UIKit

extension UIButton {
    func setRotatedLabel(text: String) {
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        titleLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        titleLabel.textAlignment = .center
        titleLabel.frame = bounds
        addSubview(titleLabel)

    }
}
