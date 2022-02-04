//
//  ViewController.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 29.01.2022.
//

import UIKit

class AuthorizationViewController: UIViewController {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loginIcon: UIImageView = {
        let image = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 60, weight: .regular, scale: .medium)
        image.image = UIImage(systemName: "key", withConfiguration: configuration)
        image.tintColor = .gray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Log In"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .systemGray
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter e-mail"
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .systemGray
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .brown
        button.setTitle("Registration", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gray
        button.setTitle("Login", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var textFieldsStackView = UIStackView()
    private var buttonsStackView = UIStackView()
    
    deinit {
        removeDarkModeNotification()
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        textFieldsStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField],
                                          axis: .vertical,
                                          spacing: 10,
                                          distribution: .fillProportionally)
        
        buttonsStackView = UIStackView(arrangedSubviews: [loginButton, registrationButton],
                                       axis: .horizontal,
                                       spacing: 10,
                                       distribution: .fillEqually)
        
        view.addSubview(backgroundView)
        backgroundView.addSubview(loginIcon)
        backgroundView.addSubview(textFieldsStackView)
        backgroundView.addSubview(buttonsStackView)
        checkColorTheme()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setConstraints()
        registerDarkModeNotification()
    }
    
    private func setupDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkColorTheme()
        navigationController?.setNavigationBarHidden(true, animated: animated)
        AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        emailTextField.text?.removeAll()
        passwordTextField.text?.removeAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }
    
    @objc private func registrationButtonTapped() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        let singUpViewController = SingUpViewController()
        self.navigationController?.pushViewController(singUpViewController,animated: true)
    }
    
    @objc private func loginButtonTapped() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        let albumViewController = AlbumsViewController()
        self.navigationController?.pushViewController(albumViewController,animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}

//MARK: - Switch color on Darkmode
extension AuthorizationViewController {
    private func registerDarkModeNotification(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkColorTheme),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    private func removeDarkModeNotification(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func checkColorTheme() {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                self.view.backgroundColor = .darkGray
                loginLabel.textColor = .white
                emailTextField.textColor = .white
                passwordTextField.textColor = .white
            }
            else {
                self.view.backgroundColor = .white
                loginLabel.textColor = .black
                emailTextField.textColor = .black
                passwordTextField.textColor = .black
            }
        }
    }
}
//MARK: - SetConstraints
extension AuthorizationViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loginIcon.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loginIcon.bottomAnchor.constraint(equalTo: textFieldsStackView.topAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            textFieldsStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            textFieldsStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            textFieldsStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            textFieldsStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            registrationButton.heightAnchor.constraint(equalToConstant: 40),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            buttonsStackView.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 30),
            buttonsStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20)
        ])
    }
}
