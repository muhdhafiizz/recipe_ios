//
//  SignInViewController.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 18/04/2025.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "The best recipe app ever"
        label.font = .systemFont(ofSize: 60, weight: .bold)
        label.numberOfLines = 5
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "signin_background"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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

    private let emailField = CustomTextField(placeholder: "")
    
    private let passwordField = CustomTextField(placeholder: "", isSecureTextEntry: true)

    private let signInButton: CustomButton = {
        let button = CustomButton(
            title: "Sign In",
            backgroundColor: .blue,
            titleColor: .white,
            cornerRadius: 10,
            font: .systemFont(ofSize: 18, weight: .semibold)
        )
        button.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        return button
    }()
    
    private let signUpButton: CustomButton = {
        let button = CustomButton(
            title: "Sign Up",
            backgroundColor: .white,
            titleColor: .blue,
            cornerRadius: 10,
            borderColor: .blue,
            borderWidth: 3,
            font: .systemFont(ofSize: 18, weight: .semibold)
        )
        button.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Sign In"
        setupBackgroundImageFade()
        setupLayout()
    }

    private func setupLayout() {
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let buttonSpacer = UIView()
        buttonSpacer.heightAnchor.constraint(equalToConstant: 20).isActive = true

        let stack = UIStackView(arrangedSubviews: [titleLabel, spacer, emailLabel, emailField, passwordLabel, passwordField, buttonSpacer, signInButton, signUpButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }


    @objc private func signInTapped() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            showAlert(message: "Please enter email and password")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(message: "Sign In Failed: \(error.localizedDescription)")
            } else {
                let mainVC = BottomNavbarViewController()
                let navVC = UINavigationController(rootViewController: mainVC)
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true)
            }
        }
    }
    
    @objc private func signUpTapped() {
        let signUpvc = SignUpViewController()
        navigationController?.pushViewController(signUpvc, animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
    
    private func setupBackgroundImageFade() {
        view.addSubview(backgroundImageView)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let gradientHeight = UIScreen.main.bounds.height * 0.55
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: gradientHeight)
        gradient.colors = [
            UIColor.black.withAlphaComponent(1).cgColor,
            UIColor.black.withAlphaComponent(0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.6)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)

        let mask = UIView(frame: gradient.frame)
        mask.layer.addSublayer(gradient)
        backgroundImageView.mask = mask
    }
}
