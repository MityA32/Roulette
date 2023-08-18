//
//  RatingViewController.swift
//  Roulette
//
//  Created by Dmytro Hetman on 16.08.2023.
//

import UIKit

class RatingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let headerPlaceholderView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private let ratingTableView = UITableView()
    private var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsersFromDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .black
//        setupPlaceholder()
        setupTableView()
    }
    
    private func setupPlaceholder() {
        view.addSubview(headerPlaceholderView)
        NSLayoutConstraint.activate([
            headerPlaceholderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerPlaceholderView.heightAnchor.constraint(equalToConstant: 40),
            headerPlaceholderView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    private func setupTableView() {
        ratingTableView.delegate = self
        ratingTableView.dataSource = self
        ratingTableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        ratingTableView.translatesAutoresizingMaskIntoConstraints = false
        
        ratingTableView.separatorStyle = .none
        view.addSubview(ratingTableView)
        NSLayoutConstraint.activate([
            ratingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ratingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ratingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ratingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
    private func fetchUsersFromDatabase() {
        UserModel.getAllUsers { users in
            self.users = users
            self.ratingTableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.configure(with: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
