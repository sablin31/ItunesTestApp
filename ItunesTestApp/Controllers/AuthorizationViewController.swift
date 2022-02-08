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
    
    private let loginIcon: UIImageView = {
        let image = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 60, weight: .regular, scale: .medium)
        image.image = UIImage(systemName: "key", withConfiguration: configuration)
        image.tintColor = .gray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
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
    
    private let alertMessage = UIAlertController(title: "Warning", message: "", preferredStyle: UIAlertController.Style.alert)
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
        alertMessage.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
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
        let mail = emailTextField.text?.lowercased() ?? ""
        let password = passwordTextField.text ?? ""
        
        if mail.isEmpty || password.isEmpty {
            alertMessage.message = "E-mail and Password can not be empty"
            self.present(alertMessage, animated: true, completion: nil)
        } else {
            let user = findUserDataUsers(mail: mail)
            if user == nil {
                alertMessage.message = "Not found user in this E-mail"
                self.present(alertMessage, animated: true, completion: nil)
            }
            else if user?.password != password {
                alertMessage.message = "Wrong password!"
                self.present(alertMessage, animated: true, completion: nil)
            } else {
                let albumViewController = AlbumsViewController()
                self.navigationController?.pushViewController(albumViewController,animated: true)
                guard let activeUser = user else {return}
                DataUsers.shared.saveActiveUser(user: activeUser)
            }
        }
    }
    
    private func findUserDataUsers(mail: String) -> User? {
        let dataUsers = DataUsers.shared.users
        for user in dataUsers {
            if user.email == mail {
                return user
            }
        }
        return nil
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
                emailTextField.textColor = .white
                passwordTextField.textColor = .white
            }
            else {
                self.view.backgroundColor = .white
                emailTextField.textColor = .black
                passwordTextField.textColor = .black
            }
        }
    }
    
//    func resetDefaults() {
//        let defaults = UserDefaults.standard
//        let dictionary = defaults.dictionaryRepresentation()
//        dictionary.keys.forEach { key in
//            defaults.removeObject(forKey: key)
//        }
//    }
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
