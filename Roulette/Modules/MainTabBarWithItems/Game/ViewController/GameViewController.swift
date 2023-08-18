//
//  GameViewController.swift
//  Roulette
//
//  Created by Dmytro Hetman on 16.08.2023.
//

import UIKit
import FirebaseAuth

class GameViewController: UIViewController {
    
    private var innerBoardNumbersCollectionView: UICollectionView?
    private let headerPlaceholderView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private let tabBarPlaceholderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let firstColumnBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("2-1", for: .normal)
        button.backgroundColor = .green
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let secondColumnBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("2-1", for: .normal)
        button.backgroundColor = .green
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let thirdColumnBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("2-1", for: .normal)
        button.backgroundColor = .green
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let bottomBetButtonsStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let firstDozenBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let secondDozenBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let thirdDozenBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        button.isUserInteractionEnabled = true
        return button
    }()
    
    
    private let rightBetButtonsStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let smallNumbersBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let bigNumbersBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let evenBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let oddBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let redBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let blackBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let leftBetButtonsStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let betZeroView = RouletteZeroView()
    let setBetView = SetBetView()
    
    var model: UserModel?
    private let betManager = BetManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let innerBoardNumbersCollectionView else { return }
        innerBoardNumbersCollectionView.heightAnchor.constraint(equalToConstant: innerBoardNumbersCollectionView.collectionViewLayout.collectionViewContentSize.height).isActive = true
        self.view.layoutIfNeeded()
        firstDozenBetButton.setRotatedLabel(text: "1st 12")
        secondDozenBetButton.setRotatedLabel(text: "2nd 12")
        thirdDozenBetButton.setRotatedLabel(text: "3rd 12")
        smallNumbersBetButton.setRotatedLabel(text: "1-18")
        bigNumbersBetButton.setRotatedLabel(text: "19-36")
        evenBetButton.setRotatedLabel(text: "Even")
        oddBetButton.setRotatedLabel(text: "Odd")
        redBetButton.setRotatedLabel(text: "Red")
        blackBetButton.setRotatedLabel(text: "Black")
    }
    
    private func setup() {
        betManager.userModel = model
        betManager.delegate = self
        guard let uid = Auth.auth().currentUser?.uid else { return }
        model?.getUserInfoBy(userID: uid, completion: { [weak self] currentUserNickname, quantityOfChips, rating in
            guard let self else { return }
            setBetView.setupStepper(by: quantityOfChips)
        })
        
        setupView()
    }
    
    private func setupView() {
        setupPlaceholder()
        setupBetView()
        setupBoard()
        setupRightBetButtons()
        setupLeftBetButtons()
        setupBottomBetButtons()
    }
    
    private func setupPlaceholder() {
        view.addSubview(headerPlaceholderView)
        NSLayoutConstraint.activate([
            headerPlaceholderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerPlaceholderView.heightAnchor.constraint(equalToConstant: 40),
            headerPlaceholderView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        view.addSubview(tabBarPlaceholderView)
        NSLayoutConstraint.activate([
            tabBarPlaceholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBarPlaceholderView.heightAnchor.constraint(equalToConstant: 0),
            tabBarPlaceholderView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    private func setupBetView() {
        setBetView.startButton.addTarget(self, action: #selector(startRoulette), for: .touchUpInside)
        
        view.addSubview(setBetView)
        NSLayoutConstraint.activate([
            setBetView.bottomAnchor.constraint(equalTo: tabBarPlaceholderView.topAnchor),
            setBetView.widthAnchor.constraint(equalTo: view.widthAnchor),
            setBetView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])
    }
    
    private func setupRightBetButtons() {
        rightBetButtonsStackView.addArrangedSubview(firstDozenBetButton)
        rightBetButtonsStackView.addArrangedSubview(secondDozenBetButton)
        rightBetButtonsStackView.addArrangedSubview(thirdDozenBetButton)
        
        firstDozenBetButton.addTarget(self, action: #selector(tappedFirstDozenBetButton), for: .touchUpInside)
        secondDozenBetButton.addTarget(self, action: #selector(tappedSecondDozenBetButton), for: .touchUpInside)
        thirdDozenBetButton.addTarget(self, action: #selector(tappedThirdDozenBetButton), for: .touchUpInside)
        
        rightBetButtonsStackView.axis = .vertical
        rightBetButtonsStackView.distribution = .fillEqually
        rightBetButtonsStackView.alignment = .fill
        rightBetButtonsStackView.spacing = 2
     view.addSubview(rightBetButtonsStackView)
     guard let innerBoardNumbersCollectionView else { return }
     NSLayoutConstraint.activate([
        rightBetButtonsStackView.trailingAnchor.constraint(equalTo: innerBoardNumbersCollectionView.leadingAnchor, constant: -16),
        rightBetButtonsStackView.topAnchor.constraint(equalTo: innerBoardNumbersCollectionView.topAnchor),
        rightBetButtonsStackView.bottomAnchor.constraint(equalTo: innerBoardNumbersCollectionView.bottomAnchor),
        rightBetButtonsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1)
     ])
    }
    
    private func setupLeftBetButtons() {
        leftBetButtonsStackView.addArrangedSubview(smallNumbersBetButton)
        leftBetButtonsStackView.addArrangedSubview(evenBetButton)
        leftBetButtonsStackView.addArrangedSubview(redBetButton)
        leftBetButtonsStackView.addArrangedSubview(blackBetButton)
        leftBetButtonsStackView.addArrangedSubview(oddBetButton)
        leftBetButtonsStackView.addArrangedSubview(bigNumbersBetButton)
        
        smallNumbersBetButton.addTarget(self, action: #selector(tappedSmallNumbersBetButton), for: .touchUpInside)
        evenBetButton.addTarget(self, action: #selector(tappedEvenBetButton), for: .touchUpInside)
        redBetButton.addTarget(self, action: #selector(tappedRedBetButton), for: .touchUpInside)
        blackBetButton.addTarget(self, action: #selector(tappedBlackBetButton), for: .touchUpInside)
        oddBetButton.addTarget(self, action: #selector(tappedOddBetButton), for: .touchUpInside)
        bigNumbersBetButton.addTarget(self, action: #selector(tappedBigNumbersBetButton), for: .touchUpInside)
        
           
           leftBetButtonsStackView.axis = .vertical
           leftBetButtonsStackView.distribution = .fillEqually
           leftBetButtonsStackView.alignment = .fill // Keep buttons' content aligned to fill
           leftBetButtonsStackView.spacing = 2
        view.addSubview(leftBetButtonsStackView)
        guard let innerBoardNumbersCollectionView else { return }
        NSLayoutConstraint.activate([
            leftBetButtonsStackView.trailingAnchor.constraint(equalTo: rightBetButtonsStackView.leadingAnchor, constant: -16),
            leftBetButtonsStackView.topAnchor.constraint(equalTo: innerBoardNumbersCollectionView.topAnchor),
            leftBetButtonsStackView.bottomAnchor.constraint(equalTo: innerBoardNumbersCollectionView.bottomAnchor),
            leftBetButtonsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1)
        ])
    }
    
    private func setupBottomBetButtons() {
        bottomBetButtonsStackView.addArrangedSubview(firstColumnBetButton)
        bottomBetButtonsStackView.addArrangedSubview(secondColumnBetButton)
        bottomBetButtonsStackView.addArrangedSubview(thirdColumnBetButton)
        
        bottomBetButtonsStackView.axis = .horizontal
        bottomBetButtonsStackView.distribution = .fillEqually
        bottomBetButtonsStackView.alignment = .fill // Keep buttons' content aligned to fill
        bottomBetButtonsStackView.spacing = 2
        
        view.addSubview(bottomBetButtonsStackView)
        guard let innerBoardNumbersCollectionView else { return }
        NSLayoutConstraint.activate([
            bottomBetButtonsStackView.trailingAnchor.constraint(equalTo: innerBoardNumbersCollectionView.trailingAnchor),
            bottomBetButtonsStackView.topAnchor.constraint(equalTo: innerBoardNumbersCollectionView.bottomAnchor, constant: 10),
            bottomBetButtonsStackView.leadingAnchor.constraint(equalTo: innerBoardNumbersCollectionView.leadingAnchor),
            bottomBetButtonsStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            bottomBetButtonsStackView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1)
        ])
    }
    
    private func setupBoard() {
        setupZeroView()
        setupCollectionView()
        
    }
    
    private func setupZeroView() {
        let tapOnZero = UITapGestureRecognizer(target: self, action: #selector(tappedZeroBetButton))
        betZeroView.addGestureRecognizer(tapOnZero)
        betZeroView.isUserInteractionEnabled = true
        view.addSubview(betZeroView)
        NSLayoutConstraint.activate([
            betZeroView.topAnchor.constraint(equalTo: headerPlaceholderView.bottomAnchor, constant: 16),
            betZeroView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            betZeroView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            betZeroView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {
    private func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        innerBoardNumbersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let innerBoardNumbersCollectionView else { return }
        
        innerBoardNumbersCollectionView.register(InnerBoardCell.self, forCellWithReuseIdentifier: "InnerBoardCell")
        innerBoardNumbersCollectionView.delegate = self
        innerBoardNumbersCollectionView.dataSource = self
        innerBoardNumbersCollectionView.backgroundColor = .white
                

        innerBoardNumbersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(innerBoardNumbersCollectionView)
        NSLayoutConstraint.activate([
            innerBoardNumbersCollectionView.topAnchor.constraint(equalTo: betZeroView.bottomAnchor),
            innerBoardNumbersCollectionView.widthAnchor.constraint(equalTo: betZeroView.widthAnchor),
            innerBoardNumbersCollectionView.trailingAnchor.constraint(equalTo: betZeroView.trailingAnchor),
//
        ])
}
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 36
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InnerBoardCell", for: indexPath) as! InnerBoardCell
       
       let slot = Slot.slots[indexPath.row]
       cell.configure(with: slot)
       return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let cellWidth = (collectionView.bounds.width - 3) / 3
       
       return CGSize(width: cellWidth, height: cellWidth * 0.6)
   }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        betManager.bet(value: Int(setBetView.betStepper.value), type: .number(indexPath.row + 1))
        print(betManager.bets)
    }
    
        
}

extension GameViewController {
    
    @objc private func tappedSmallNumbersBetButton() {
        betManager.bet(value: Int(setBetView.betStepper.value), type: .smallNumbers)
    }
    @objc private func tappedEvenBetButton() {
        betManager.bet(value: Int(setBetView.betStepper.value), type: .evenNumbers)
    }
    @objc private func tappedRedBetButton() {
        betManager.bet(value: Int(setBetView.betStepper.value), type: .redNumbers)
    }
    @objc private func tappedBlackBetButton() {
        betManager.bet(value: Int(setBetView.betStepper.value), type: .blackNumbers)
    }
    @objc private func tappedOddBetButton() {
        betManager.bet(value: Int(setBetView.betStepper.value), type: .oddNumbers)
    }
    @objc private func tappedBigNumbersBetButton() {
        betManager.bet(value: Int(setBetView.betStepper.value), type: .bigNumbers)
    }
    @objc private func tappedFirstDozenBetButton() {
        betManager.bet(value: Int(setBetView.betStepper.value), type: .firstDozen)
    }
    @objc private func tappedSecondDozenBetButton() {
        betManager.bet(value: Int(setBetView.betStepper.value), type: .secondDozen)
    }
    @objc private func tappedThirdDozenBetButton() {
        betManager.bet(value: Int(setBetView.betStepper.value), type: .thirdDozen)
    }
    @objc private func tappedFirstColumnBetButton() {
        betManager.bet(value: Int(setBetView.betStepper.value), type: .firstColumn)
    }
    @objc private func tappedSecondColumnBetButton() {
        betManager.bet(value: Int(setBetView.betStepper.value), type: .secondColumn)
    }
    @objc private func tappedThirdColumnBetButton() {
        betManager.bet(value: Int(setBetView.betStepper.value), type: .thirdColumn)
    }
    @objc private func tappedZeroBetButton() {
        betManager.bet(value: Int(setBetView.betStepper.value), type: .zero)
    }
    
    @objc private func startRoulette() {
        betManager.startRoulette()
    }
}
