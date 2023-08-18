//
//  SetBetView.swift
//  Roulette
//
//  Created by Dmytro Hetman on 18.08.2023.
//

import UIKit

class SetBetView: UIView {

    let betValueLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.text = "Bet: 0"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let betStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    let startButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        startButton.layer.backgroundColor = UIColor.systemGreen.cgColor
        startButton.layer.cornerRadius = startButton.frame.height / 2
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    func setupStepper(by balance: Int) {
        betStepper.minimumValue = 0
        betStepper.maximumValue = Double(balance)
        betStepper.stepValue = Double(balance / 10)
        betStepper.value = 0
        betStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)

    }
    
    @objc private func stepperValueChanged(_ stepper: UIStepper) {
        let newValue = Int(stepper.value)
        betValueLabel.text = "Bet: \(newValue)"
        
    }
    
    private func setupView() {
        backgroundColor = .black
        addSubview(betValueLabel)
        
        NSLayoutConstraint.activate([
            betValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            betValueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            betValueLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            betValueLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25)
        ])
        
        addSubview(betStepper)
        
        NSLayoutConstraint.activate([
            betStepper.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            betStepper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            betStepper.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            betStepper.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25)
        ])
        
        addSubview(startButton)
        
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: betValueLabel.trailingAnchor, constant: 32),
            startButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            startButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            startButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }

}
