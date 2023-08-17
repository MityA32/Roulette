//
//  CustomHeaderBar.swift
//  Roulette
//
//  Created by Dmytro Hetman on 16.08.2023.
//

import UIKit

class CustomHeaderBar: UIView {
    
    let profileImage = UIImageView()
    let nicknameLabel = UILabel()
    let quantityOfChipsLabel = UILabel()
    
    var nickname: String
    var quantityOfChips: String
    
    init(labelText: String, quantityOfChips: String) {
        self.nickname = labelText
        self.quantityOfChips = quantityOfChips
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .green
        
        translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.image = UIImage(systemName: "person.circle")
        
        addSubview(profileImage)
        
        
        quantityOfChipsLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityOfChipsLabel.text = "\(quantityOfChips)"
        quantityOfChipsLabel.addImage(imageName: "coins_icon")
        quantityOfChipsLabel.textAlignment = .center
        
        addSubview(quantityOfChipsLabel)
        
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.text = nickname
        nicknameLabel.textColor = .white
        
        addSubview(nicknameLabel)
        
        
        
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor),
            
            
            quantityOfChipsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            quantityOfChipsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            quantityOfChipsLabel.heightAnchor.constraint(equalTo: heightAnchor),
            quantityOfChipsLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            
            nicknameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 20),
            nicknameLabel.trailingAnchor.constraint(equalTo: quantityOfChipsLabel.leadingAnchor, constant: -20),
            nicknameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            nicknameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            
        ])
    }
    
}

extension UILabel {
    func addImage(imageName: String, afterLabel bolAfterLabel: Bool = false, spacing: CGFloat = 8.0) {
            let attachment: NSTextAttachment = NSTextAttachment()
            attachment.image = UIImage(named: imageName)
            attachment.setImageHeight(height: 20)
            let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
            
            let spaceAttachment: NSTextAttachment = NSTextAttachment()
            spaceAttachment.image = UIImage()
            spaceAttachment.bounds = CGRect(x: 0, y: 0, width: spacing, height: 20)
            let spaceAttachmentString: NSAttributedString = NSAttributedString(attachment: spaceAttachment)

            if bolAfterLabel {
                let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
                strLabelText.append(spaceAttachmentString)
                strLabelText.append(attachmentString)

                self.attributedText = strLabelText
            } else {
                let strLabelText: NSAttributedString = NSAttributedString(string: self.text!)
                let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
                mutableAttachmentString.append(spaceAttachmentString)
                mutableAttachmentString.append(strLabelText)

                self.attributedText = mutableAttachmentString
            }
        }


    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}

extension NSTextAttachment {
    func setImageHeight(height: CGFloat) {
        guard let image = image else { return }
        let ratio = image.size.width / image.size.height

        bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: ratio * height, height: height)
    }
}
