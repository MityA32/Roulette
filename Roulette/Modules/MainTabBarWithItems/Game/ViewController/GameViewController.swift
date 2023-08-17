//
//  GameViewController.swift
//  Roulette
//
//  Created by Dmytro Hetman on 16.08.2023.
//

import UIKit
import FirebaseAuth

class GameViewController: UIViewController {
    
    
    
    var model: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setup()
    }
    
    private func setup() {
        
        setupView()
    }
    
    private func setupView() {
//        setupHeaderView()
    }
}
