//
//  SignUpViewController.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 18/04/2025.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    private lazy var customNavBar = NavBar(title: "")
    
    private let signupTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Join us to start cooking"
        label.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        label.numberOfLines = 5
        label.textAlignment = .left
        label.textColor = .blue
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .blue
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .blue
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .blue
        return label
    }()
    
    private let nameTextField: CustomTextField = {
        let tf = CustomTextField(
            placeholder: "Full Name"
        )
        return tf
    }()

    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(
            placeholder: "Email"
        )
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(
            placeholder: "Password",
            isSecureTextEntry: true
        )
        return tf
    }()
    
    private let signUpButton: CustomButton = {
        let btn = CustomButton(
            title: "Join us now",
            backgroundColor: .blue,
            titleColor: .white,
            cornerRadius: 10,
            font: .systemFont(ofSize: 18, weight: .semibold)
        )
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return btn
    }()
    
    private let errorLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .red
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textAlignment = .center
        lbl.isHidden = true
        return lbl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(customNavBar)
        customNavBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        setupLayout()
    }

    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [
            signupTextLabel,
            nameLabel,
            nameTextField,
            emailLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            signUpButton,
            errorLabel
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 60),
            
            stack.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: 32),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    @objc private func handleSignUp() {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showError("Please fill in all fields.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.showError("Sign up failed: \(error.localizedDescription)")
                return
            }
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = name
            changeRequest?.commitChanges { error in
                if let error = error {
                    self?.showError("Failed to set display name: \(error.localizedDescription)")
                    return
                }

                print("✅ Display name updated in Firebase Auth")
                self?.errorLabel.isHidden = true
                self?.navigateToHome()
            }
        }
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    private func navigateToHome() {
        let homeVC = BottomNavbarViewController()
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: true)
    }
}
