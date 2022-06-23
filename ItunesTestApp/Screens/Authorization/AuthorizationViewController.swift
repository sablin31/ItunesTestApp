//
//  ViewController.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 29.01.2022.
//

import UIKit

protocol AuthorizationDisplayLogic: AnyObject {
    var interactor: AuthorizationInteractor? { get set }
    var router: RouterProtocol? { get set }

    func showResultAuthorization(viewModel: AuthorizationModels.CheckUser.ViewModel)
}

final class AuthorizationViewController: UIViewController {
    // MARK: - Public properties

    var interactor: AuthorizationInteractor?
    var router: RouterProtocol?
    // MARK: - UI properties

    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let loginIcon: UIImageView = {
        let image = UIImageView()
        let configuration = UIImage.SymbolConfiguration(
            pointSize: Constants.loginIconPointSize,
            weight: .regular,
            scale: .medium
        )
        image.image = UIImage(
            systemName: Constants.loginIconName,
            withConfiguration: configuration
        )
        image.tintColor = .gray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .systemGray
        textField.borderStyle = .roundedRect
        textField.placeholder = Constants.emailTextFieldPlaceholderName
        textField.tag = Constants.emailTextFieldTag
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .systemGray
        textField.borderStyle = .roundedRect
        textField.placeholder = Constants.passwordTextFieldPlaceholderName
        textField.isSecureTextEntry = true
        textField.tag = Constants.passwordTextFieldTag
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gray
        button.setTitle(Constants.loginButtonTitle, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = Constants.loginButtonCornerRadius
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .brown
        button.setTitle(Constants.registrationButtonTitle, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = Constants.registrationButtonCornerRadius
        button.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var textFieldsStackView = UIStackView()
    private var buttonsStackView = UIStackView()
    // MARK: - Inheritance

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupDelegate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        lockOrientation(
            UIInterfaceOrientationMask.portrait,
            andRotateTo: UIInterfaceOrientation.portrait
        )
        emailTextField.text?.removeAll()
        passwordTextField.text?.removeAll()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        lockOrientation(UIInterfaceOrientationMask.all)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            changeColorUI(to: traitCollection.userInterfaceStyle)
        }
    }
    // MARK: - Action methods

    @objc private func registrationButtonTapped() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        router?.routeToSignUpScreen()
    }

    @objc private func loginButtonTapped() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        loginUser(mail: emailTextField.text, password: passwordTextField.text)
    }
}
// MARK: - UITextFieldDelegate methods

extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
            if let nextResponder = textField.superview?.viewWithTag(nextTag) {
                nextResponder.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        return true
    }
}
// MARK: - Private methods

private extension AuthorizationViewController {
    func configureUI() {
          setupViews()
          changeColorUI(to: traitCollection.userInterfaceStyle)
          setConstraints()
    }

    func setupViews() {
        textFieldsStackView = UIStackView(
            arrangedSubviews: [emailTextField, passwordTextField],
            axis: .vertical,
            spacing: Constants.textFieldsStackViewSpacing,
            distribution: .fillProportionally
        )

        buttonsStackView = UIStackView(
            arrangedSubviews: [loginButton, registrationButton],
            axis: .horizontal,
            spacing: Constants.buttonsStackViewSpacing,
            distribution: .fillEqually
        )

        view.addSubview(backgroundView)
        backgroundView.addSubview(loginIcon)
        backgroundView.addSubview(textFieldsStackView)
        backgroundView.addSubview(buttonsStackView)
    }

    func setupDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    func changeColorUI(to currentUserInterfaceStyle: UIUserInterfaceStyle) {
        if currentUserInterfaceStyle == .dark {
            view.backgroundColor = .darkGray
            emailTextField.textColor = .white
            passwordTextField.textColor = .white
        } else {
            view.backgroundColor = .white
            emailTextField.textColor = .black
            passwordTextField.textColor = .black
        }
    }

    func loginUser(mail login: String?, password: String?) {
        let request = AuthorizationModels.CheckUser.Request(
            login: login?.lowercased() ?? "",
            password: password ?? ""
        )
        interactor?.checkCurrentUser(request: request)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            loginIcon.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loginIcon.bottomAnchor.constraint(
                equalTo: textFieldsStackView.topAnchor,
                constant: Constants.loginIconBottomAnchor
            )
        ])

        NSLayoutConstraint.activate([
            textFieldsStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            textFieldsStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            textFieldsStackView.leadingAnchor.constraint(
                equalTo: backgroundView.leadingAnchor,
                constant: Constants.texFieldsStackViewLeadingAnchor
            ),
            textFieldsStackView.trailingAnchor.constraint(
                equalTo: backgroundView.trailingAnchor,
                constant: Constants.texFieldsStackViewTrailingAnchor
            )
        ])

        NSLayoutConstraint.activate([
            registrationButton.heightAnchor.constraint(
                equalToConstant: Constants.registrationButtonHeightAnchor
            ),
            loginButton.heightAnchor.constraint(
                equalToConstant: Constants.loginButtonHeightAnchor
            )
        ])

        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(
                equalTo: textFieldsStackView.bottomAnchor,
                constant: Constants.buttonsStackViewTopAnchor
            ),
            buttonsStackView.leadingAnchor.constraint(
                equalTo: backgroundView.leadingAnchor,
                constant: Constants.buttonsStackViewLeadingAnchor
            ),
            buttonsStackView.trailingAnchor.constraint(
                equalTo: backgroundView.trailingAnchor,
                constant: Constants.buttonsStackViewTrailingAnchor
            )
        ])
    }
}
// MARK: - AuthorizationDisplayLogic

extension AuthorizationViewController: AuthorizationDisplayLogic {
    func showResultAuthorization(viewModel: AuthorizationModels.CheckUser.ViewModel) {
        if viewModel.resultAuthorization == false {
            self.showAlert(
                titleMessage: Constants.alertTitleDefault,
                message: viewModel.descriptionOperation,
                titleButton: Constants.alertActionTitle
            )
        } else {
            router?.routeToAlbumsScreen()
        }
    }
}
// MARK: - Constants

extension AuthorizationViewController {
    private enum Constants {
        // MARK: UI constants

        static let loginIconName = "key"
        static let loginIconPointSize: CGFloat = 60.0

        static let textFieldsStackViewSpacing: CGFloat = 10
        static let buttonsStackViewSpacing: CGFloat = 10

        static let emailTextFieldPlaceholderName = "E-mail"
        static let emailTextFieldTag = 1
        static let passwordTextFieldPlaceholderName = "Password"
        static let passwordTextFieldTag = 2

        static let loginButtonTitle = "Login"
        static let loginButtonCornerRadius: CGFloat = 10

        static let registrationButtonTitle = "Registration"
        static let registrationButtonCornerRadius: CGFloat = 10

        static let alertTitleDefault = "Warning"
        static let alertActionTitle = "OK"

        // MARK: Constraint constants

        static let loginIconBottomAnchor: CGFloat = -30

        static let texFieldsStackViewLeadingAnchor: CGFloat = 20
        static let texFieldsStackViewTrailingAnchor: CGFloat = -20

        static let registrationButtonHeightAnchor: CGFloat = 40
        static let loginButtonHeightAnchor: CGFloat = 40

        static let buttonsStackViewTopAnchor: CGFloat = 30
        static let buttonsStackViewLeadingAnchor: CGFloat = 20
        static let buttonsStackViewTrailingAnchor: CGFloat = -20
    }
}
