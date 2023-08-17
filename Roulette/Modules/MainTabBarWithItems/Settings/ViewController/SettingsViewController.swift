//
//  SettingsViewController.swift
//  Roulette
//
//  Created by Dmytro Hetman on 16.08.2023.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    let settingsOptionsTableView = UITableView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    private func setup() {
        setupView()
    }
    
    private func setupView() {
        setupTableView()
    }
    
    private func setupTableView() {
        settingsOptionsTableView.delegate = self
        settingsOptionsTableView.dataSource = self
        settingsOptionsTableView.register(SettingsOptionTableViewCell.self, forCellReuseIdentifier: SettingsOptionTableViewCell.cellIdentifier)
        settingsOptionsTableView.translatesAutoresizingMaskIntoConstraints = false
        settingsOptionsTableView.isScrollEnabled = false
        settingsOptionsTableView.separatorStyle = .none
        view.addSubview(settingsOptionsTableView)
        
        NSLayoutConstraint.activate([
            settingsOptionsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            settingsOptionsTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            settingsOptionsTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsOptionsTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75)
        ])
        
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SettingsOptionsType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsOptionsTableView.dequeueReusableCell(withIdentifier: SettingsOptionTableViewCell.cellIdentifier, for: indexPath) as! SettingsOptionTableViewCell
        cell.delegate = self
        cell.configure(from: SettingsOptionsType.allCases[indexPath.row])
        return cell
    }
    
    
    
    
}
