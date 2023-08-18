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
    
    private let betZeroView = RouletteZeroView()
    private let setBetView = SetBetView()
    
    private let firstColumnBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("1st column", for: .normal)
        return button
    }()
    
    private let secondColumnBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("2nd column", for: .normal)
        return button
    }()
    
    private let thirdColumnBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("3rd column", for: .normal)
        return button
    }()
    
    private let firstDozenBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("1st 12", for: .normal)
        return button
    }()
    
    private let secondDozenBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("2nd 12", for: .normal)
        return button
    }()
    
    private let thirdDozenBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("3rd 12", for: .normal)
        return button
    }()
    
    private let smallNumbersBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("1-18", for: .normal)
        return button
    }()
    
    private let bigNumbersBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("19-36", for: .normal)
        return button
    }()
    
    private let evenBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Even", for: .normal)
        return button
    }()
    
    private let oddBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Odd", for: .normal)
        return button
    }()
    
    private let redBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Red", for: .normal)
        return button
    }()
    
    private let blackBetButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Black", for: .normal)
        return button
    }()
    
    var model: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setup()
    }
    
    private func setup() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        model?.getUserInfoBy(userID: uid, completion: { [weak self] currentUserNickname, quantityOfChips, rating in
            guard let self else { return }
            
            guard let balance = Int(quantityOfChips) else { return }
            setBetView.setupStepper(by: balance)
        })
        
        setupView()
    }
    
    private func setupView() {
        setupPlaceholder()
        setupBetView()
        setupBoard()
        
        
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
        view.addSubview(setBetView)
        NSLayoutConstraint.activate([
            setBetView.bottomAnchor.constraint(equalTo: tabBarPlaceholderView.topAnchor),
            setBetView.widthAnchor.constraint(equalTo: view.widthAnchor),
            setBetView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])
    }
    
    private func setupBoard() {
        setupZeroView()
        setupCollectionView()
        
    }
    
    private func setupZeroView() {
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
            innerBoardNumbersCollectionView.bottomAnchor.constraint(equalTo: setBetView.topAnchor)
        ])
}
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // Return the number of segments on the inner board
       return 36 // For example, 0-36
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InnerBoardCell", for: indexPath) as! InnerBoardCell
       
       // Configure the cell with number and color
       let slot = Slot.slots[indexPath.row]
       cell.configure(with: slot)
       
       return cell
           
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       // Adjust the cell size based on your design
       let cellWidth = (collectionView.bounds.width - 3) / 3
       
       return CGSize(width: cellWidth, height: cellWidth * 0.6)
   }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row + 1)
    }
    
        
}
