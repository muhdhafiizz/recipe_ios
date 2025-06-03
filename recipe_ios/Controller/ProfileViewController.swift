//
//  ProfileViewController.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 18/04/2025.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let options = ["Sign Out"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupTableView() {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Profile"
            label.font = UIFont.boldSystemFont(ofSize: 30)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.isScrollEnabled = false
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }

        let option = options[indexPath.row]
        var icon: UIImage?

        switch option {
        case "Sign Out":
            icon = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        
        default:
            break
        }

        cell.configure(title: option, icon: icon)
        return cell
    }


    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if options[indexPath.row] == "Sign Out" {
            presentSignOutAlert()
        } else {
            print("Else")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    private func presentSignOutAlert() {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            self.signOut()
        }))
        present(alert, animated: true)
    }

    private func signOut() {
        do {
            try Auth.auth().signOut()
            let loginVC = SignInViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController = nav
        } catch {
            print("Sign out failed: \(error.localizedDescription)")
        }
    }
}

