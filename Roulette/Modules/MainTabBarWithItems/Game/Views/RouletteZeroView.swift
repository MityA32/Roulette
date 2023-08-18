//
//  RouletteZeroView.swift
//  Roulette
//
//  Created by Dmytro Hetman on 18.08.2023.
//

import UIKit

class RouletteZeroView: UIView {
    
    private let zeroLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "0"
        label.textColor = .white
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(zeroLabel)
        NSLayoutConstraint.activate([
            zeroLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            zeroLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.addPath(createZeroPath(in: rect))
        context.setFillColor(UIColor.green.cgColor)
        context.fillPath()
    }
    
    private func createZeroPath(in rect: CGRect) -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.4))
        path.addLine(to: CGPoint(x: rect.width * 0.5, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.4))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.close()
        return path.cgPath
    }
}


