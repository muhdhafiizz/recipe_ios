//
//  SignInViewController.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 18/04/2025.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        // Add scroll view and content view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        ])
        
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let buttonSpacer = UIView()
        buttonSpacer.heightAnchor.constraint(equalToConstant: 20).isActive = true

        let stack = UIStackView(arrangedSubviews: [titleLabel, spacer, emailLabel, emailField, passwordLabel, passwordField, buttonSpacer, signInButton, signUpButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        // Add keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll to make it visible
        var aRect = view.frame
        aRect.size.height -= keyboardFrame.height
        
        if let activeField = [emailField, passwordField].first(where: { $0.isFirstResponder }) {
            let activeFieldFrame = activeField.convert(activeField.bounds, to: scrollView)
            if !aRect.contains(activeFieldFrame.origin) {
                scrollView.scrollRectToVisible(activeFieldFrame, animated: true)
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
