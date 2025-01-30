//
//  LoginController.swift
//  swift-login-system
//
//  Created by elif uyar on 2.11.2024.
//

/*import UIKit

class LoginController: UIViewController {
    
        private let headerView = AuthHeaderView(title: "Sign In", subTitle: "Sign in to your account")
        
        private let emailField = CustomTextField(fieldType: .email)
        private let passwordField = CustomTextField(fieldType: .password)
        
        private let signInButton = CustomButton(title: "Sign In", hasBackground: true, fontSize: .big)
        private let newUserButton = CustomButton(title: "New User? Create Account.", fontSize: .med)
        private let forgotPasswordButton = CustomButton(title: "Forgot Password?", fontSize: .small)
        
        // MARK: - LifeCycle
        override func viewDidLoad() {
            super.viewDidLoad()
            self.setupUI()
            
            self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
            self.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
            self.forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.navigationBar.isHidden = true
            
        }
        
        // MARK: - UI Setup
        private func setupUI() {
            self.view.backgroundColor = .systemBackground
            
            self.view.addSubview(headerView)
            self.view.addSubview(emailField)
            self.view.addSubview(passwordField)
            self.view.addSubview(signInButton)
            self.view.addSubview(newUserButton)
            self.view.addSubview(forgotPasswordButton)
            
            headerView.translatesAutoresizingMaskIntoConstraints = false
            emailField.translatesAutoresizingMaskIntoConstraints = false
            passwordField.translatesAutoresizingMaskIntoConstraints = false
            signInButton.translatesAutoresizingMaskIntoConstraints = false
            newUserButton.translatesAutoresizingMaskIntoConstraints = false
            forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
                self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.headerView.heightAnchor.constraint(equalToConstant: 222),
                
                self.emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
                self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.emailField.heightAnchor.constraint(equalToConstant: 55),
                self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
                self.passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.passwordField.heightAnchor.constraint(equalToConstant: 55),
                self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
                self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.signInButton.heightAnchor.constraint(equalToConstant: 55),
                self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 11),
                self.newUserButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.newUserButton.heightAnchor.constraint(equalToConstant: 44),
                self.newUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.forgotPasswordButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: 6),
                self.forgotPasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.forgotPasswordButton.heightAnchor.constraint(equalToConstant: 44),
                self.forgotPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            ])
        }
        
        // MARK: - Selectors
    @objc private func didTapSignIn() {
        let loginRequest = LoginUserRequest(
            email: self.emailField.text ?? "",
            password: self.passwordField.text ?? ""
        )
        
        // Email check
        if !Validator.isValidEmail(for: loginRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        // Password check
        if !Validator.isPasswordValid(for: loginRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        AuthService.shared.signIn(with: loginRequest) { error in
            if let error = error {
                AlertManager.showSignInErrorAlert(on: self, with: error)
                return
            }
            
            
            let profileVC = MainViewController()
            profileVC.modalPresentationStyle = .fullScreen
            self.present(profileVC, animated: true, completion: nil)
        }
    }

        
        @objc private func didTapNewUser() {
            let vc = RegisterController()
            self.navigationController?.pushViewController(vc, animated: true )
        }
        
        @objc private func didTapForgotPassword() {
            let vc = ForgotPasswordController()
            self.navigationController?.pushViewController(vc, animated: true )
        }
}
*/
import UIKit

class LoginController: UIViewController {
    
        
        
    private let headerView = AuthHeaderView(title: "Sign In", subTitle: "Sign in to your account")

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            self.headerView.subTitleLabel.textColor = .white
        }
    
        private let emailField: CustomTextField = {
            let field = CustomTextField(fieldType: .email)
            field.textColor = .white
            field.backgroundColor = .black
            field.attributedPlaceholder = NSAttributedString(
                string: "Enter your email",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
            return field
        }()

        private let passwordField: CustomTextField = {
            let field = CustomTextField(fieldType: .password)
            field.textColor = .white
            field.backgroundColor = .black
            field.attributedPlaceholder = NSAttributedString(
                string: "Enter your password",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
            return field
        }()

        private let signInButton: CustomButton = {
            let button = CustomButton(title: "Sign In", hasBackground: true, fontSize: .big)
            button.backgroundColor = .black
            button.setTitleColor(.white, for: .normal)
            return button
        }()

        private let newUserButton: CustomButton = {
            let button = CustomButton(title: "New User? Create Account.", fontSize: .med)
            button.backgroundColor = .clear
            button.setTitleColor(.white, for: .normal)
            return button
        }()

        private let forgotPasswordButton: CustomButton = {
            let button = CustomButton(title: "Forgot Password?", fontSize: .small)
            button.backgroundColor = .clear
            button.setTitleColor(.white, for: .normal)
            return button
        }()
        
        // MARK: - LifeCycle
        override func viewDidLoad() {
            super.viewDidLoad()
            self.setupUI()
            
            self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
            self.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
            self.forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.navigationBar.isHidden = true
            
        }
        
        // MARK: - UI Setup
        private func setupUI() {
            self.view.backgroundColor = .black
            
            self.view.addSubview(headerView)
            self.view.addSubview(emailField)
            self.view.addSubview(passwordField)
            self.view.addSubview(signInButton)
            self.view.addSubview(newUserButton)
            self.view.addSubview(forgotPasswordButton)
            
            headerView.translatesAutoresizingMaskIntoConstraints = false
            emailField.translatesAutoresizingMaskIntoConstraints = false
            passwordField.translatesAutoresizingMaskIntoConstraints = false
            signInButton.translatesAutoresizingMaskIntoConstraints = false
            newUserButton.translatesAutoresizingMaskIntoConstraints = false
            forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
                self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.headerView.heightAnchor.constraint(equalToConstant: 222),
                
                self.emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
                self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.emailField.heightAnchor.constraint(equalToConstant: 55),
                self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
                self.passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.passwordField.heightAnchor.constraint(equalToConstant: 55),
                self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
                self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.signInButton.heightAnchor.constraint(equalToConstant: 55),
                self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 11),
                self.newUserButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.newUserButton.heightAnchor.constraint(equalToConstant: 44),
                self.newUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.forgotPasswordButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: 6),
                self.forgotPasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.forgotPasswordButton.heightAnchor.constraint(equalToConstant: 44),
                self.forgotPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            ])
        }
        
        // MARK: - Selectors
    @objc private func didTapSignIn() {
        let loginRequest = LoginUserRequest(
            email: self.emailField.text ?? "",
            password: self.passwordField.text ?? ""
        )
        
        // Email check
        if !Validator.isValidEmail(for: loginRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        // Password check
        if !Validator.isPasswordValid(for: loginRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        AuthService.shared.signIn(with: loginRequest) { error in
            if let error = error {
                AlertManager.showSignInErrorAlert(on: self, with: error)
                return
            }
            
            
            let profileVC = MainViewController()
            profileVC.modalPresentationStyle = .fullScreen
            self.present(profileVC, animated: true, completion: nil)
        }
    }

        
        @objc private func didTapNewUser() {
            let vc = RegisterController()
            self.navigationController?.pushViewController(vc, animated: true )
        }
        
        @objc private func didTapForgotPassword() {
            let vc = ForgotPasswordController()
            self.navigationController?.pushViewController(vc, animated: true )
        }
}
