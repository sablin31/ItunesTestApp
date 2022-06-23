//
//  SingUpViewController.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 29.01.2022.
//

import UIKit

protocol SignUpDisplayLogic: AnyObject {
    var interactor: SignUpInteractor? { get set }
    var router: RouterProtocol? { get set }

    func showResultValidationTextField(viewModel: SignUpModels.ValidateTextFields.ViewModel)
    func showResultValidationAge(viewModel: SignUpModels.ValidateAge.ViewModel)
    func showResultValidationPhone(viewModel: SignUpModels.ValidatePhone.ViewModel)
    func showResultRegistration(viewModel: SignUpModels.RegistrationUser.ViewModel)
}

class SignUpViewController: UIViewController {
    // MARK: - Public properties

    var interactor: SignUpInteractor?
    var router: RouterProtocol?
    // MARK: - Private properties

    private var firstNameIsValid = false
    private var lastNameIsValid = false
    private var ageIsValid = false
    private var phoneIsValid = false
    private var emailIsValid = false
    private var passwordIsValid = false
    // MARK: - UI properties

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.loginLabelText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = Constants.firstNameTextFieldPlaceholder
        textField.tag = Constants.firstNameTextFieldTag
        textField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let firstNameValidLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.labelPlug
        label.font = UIFont.systemFont(ofSize: Constants.firstNameFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = Constants.lastNameTextFieldPlaceholder
        textField.tag = Constants.lastNameTextFieldTag
        textField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let lastNameValidLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.labelPlug
        label.font = UIFont.systemFont(ofSize: Constants.lastNameFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.clipsToBounds = false
        datePicker.tintColor = .black
        datePicker.contentHorizontalAlignment = .left
        datePicker.addTarget(
            self,
            action: #selector(datePickerDidChanged(picker:)),
            for: .valueChanged
        )
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()

    private let ageValidLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.labelPlug
        label.font = UIFont.systemFont(ofSize: Constants.ageFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = Constants.phoneTextFieldPlaceholder
        textField.keyboardType = .numberPad
        textField.tag = Constants.phoneTextFieldTag
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let phoneValidLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.labelPlug
        label.font = UIFont.systemFont(ofSize: Constants.phoneFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = Constants.emailTextFieldPlaceholder
        textField.tag = Constants.emailTextFieldTag
        textField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let emailValidLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.labelPlug
        label.font = UIFont.systemFont(ofSize: Constants.emailFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        textField.placeholder = Constants.passwordTextFieldPlaceholder
        textField.tag = Constants.passwordTextFieldTag
        textField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let passwordValidLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.labelPlug
        label.font = UIFont.systemFont(ofSize: Constants.passwordFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .brown
        button.setTitle(Constants.createAccountButtonTitle, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = Constants.createAccountButtonCornerRadius
        button.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var returnButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gray
        button.setTitle(Constants.returnButtonTitle, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = Constants.returnButtonCornerRadius
        button.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var elementStackView = UIStackView()
    private var buttonsStackView = UIStackView()
    // MARK: - Init

    deinit {
        removeKeyboardNotification()
    }
    // MARK: - Inheritance

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupDelegate()
        registerKeyboardNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
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

    @objc override func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardHeight = (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        
        if emailTextField.isFirstResponder || passwordTextField.isFirstResponder {
            scrollView.contentOffset = CGPoint(
                x: .zero,
                y: (keyboardHeight?.height ?? .zero) / 2
            )
        } else { scrollView.contentOffset = CGPoint.zero }
    }

    @objc override func keyboardWillHide(notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
    // MARK: - Action methods

    @objc private func textFieldDidChange(_ textField: UITextField) {
        var validTypes: String.ValidTypes

        guard let text = textField.text else { return }

        switch (textField.tag) {
        case Constants.firstNameTextFieldTag: validTypes = .name
        case Constants.lastNameTextFieldTag: validTypes = .name
        case Constants.emailTextFieldTag: validTypes = .email
        case Constants.passwordTextFieldTag: validTypes = .password
        default: return
        }

        let request = SignUpModels.ValidateTextFields.Request(
            field: text,
            validTypes: validTypes,
            tag: textField.tag
        )
        interactor?.validateTextField(request: request)
    }

    @objc private func datePickerDidChanged(picker: UIDatePicker) {
        let request = SignUpModels.ValidateAge.Request(
            bightday: datePicker.date
        )
        interactor?.validateAge(request: request)
    }

    @objc private func createAccountButtonTapped(){
        let request = SignUpModels.RegistrationUser.Request(
            firstName: firstNameTextField.text ?? "",
            lastName: lastNameTextField.text ?? "",
            age: datePicker.date,
            phone: phoneNumberTextField.text ?? "",
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
        interactor?.registrationUser(request: request)
    }

    @objc private func returnButtonTapped(){
        self.navigationController?.popToRootViewController(animated: true)
        router?.popToRoot()
    }

    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        returnButtonTapped()
    }
}
// MARK: - SignUpDisplayLogic Delegate

extension SignUpViewController: SignUpDisplayLogic {
    func showResultValidationTextField(viewModel: SignUpModels.ValidateTextFields.ViewModel) {
        switch (viewModel.tag) {
        case Constants.firstNameTextFieldTag:
            firstNameValidLabel.text = viewModel.resultIsValidLabel
            firstNameValidLabel.textColor = viewModel.resultIsValid ? .green : .red
            firstNameIsValid = viewModel.resultIsValid
        case Constants.lastNameTextFieldTag:
            lastNameValidLabel.text = viewModel.resultIsValidLabel
            lastNameValidLabel.textColor = viewModel.resultIsValid ? .green : .red
            lastNameIsValid = viewModel.resultIsValid
        case Constants.emailTextFieldTag:
            emailValidLabel.text = viewModel.resultIsValidLabel
            emailValidLabel.textColor = viewModel.resultIsValid ? .green : .red
            emailIsValid = viewModel.resultIsValid
        case Constants.passwordTextFieldTag:
            passwordValidLabel.text = viewModel.resultIsValidLabel
            passwordValidLabel.textColor = viewModel.resultIsValid ? .green : .red
            passwordIsValid = viewModel.resultIsValid
        default:
            return
        }
        checkFields()
    }

    func showResultValidationAge(viewModel: SignUpModels.ValidateAge.ViewModel) {
        ageValidLabel.text = viewModel.resultAgeIsValidLabel
        ageValidLabel.textColor = viewModel.resultAgeIsValid ? .green : .red
        ageIsValid = viewModel.resultAgeIsValid
        checkFields()
    }

    func showResultValidationPhone(viewModel: SignUpModels.ValidatePhone.ViewModel) {
        phoneValidLabel.text = viewModel.resultPhoneIsValidLabel
        phoneValidLabel.textColor = viewModel.resultPhoneIsValid ? .green : .red
        phoneIsValid = viewModel.resultPhoneIsValid
        checkFields()
    }

    func showResultRegistration(viewModel: SignUpModels.RegistrationUser.ViewModel) {
        let status = viewModel.status
        switch status {
        case .succsess:
            showAlert(
                titleMessage: Constants.succsessAlertTitle,
                message: viewModel.description,
                titleButton: Constants.buttonAlertTitle
            ){
                (action: UIAlertAction!) in
                self.view.endEditing(true)
                self.router?.popToRoot()
            }
        case .userAlreadyExist, .notCorrectRegData:
            showAlert(
                titleMessage: Constants.failureAlertTitle,
                message: viewModel.description,
                titleButton: Constants.buttonAlertTitle
            )
        }
    }
}
// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if textField.tag == Constants.phoneTextFieldTag {
            setTextFieldPhoneNumber(
                textField: textField,
                pattern: Constants.phonePattern,
                replacementCharacter: Constants.phoneReplacementCharacter,
                string: string,
                range: range
            )
            if let phone = textField.text {
                let request = SignUpModels.ValidatePhone.Request(
                    phoneNumber: phone,
                    pattern: Constants.phonePattern
                )
                interactor?.validatePhone(request: request)
            }
            return false
        } else {
            return true
        }
    }
}
// MARK: - Private methods

private extension SignUpViewController {
    func configureUI() {
        setupViews()
        changeColorUI(to: traitCollection.userInterfaceStyle)
        setConstraints()
        addGesture()
        view.isUserInteractionEnabled = true
    }

    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(loginLabel)

        elementStackView = UIStackView(
            arrangedSubviews: [
                firstNameTextField,
                firstNameValidLabel,
                lastNameTextField,
                lastNameValidLabel,
                datePicker,
                ageValidLabel,
                phoneNumberTextField,
                phoneValidLabel,
                emailTextField,
                emailValidLabel,
                passwordTextField,
                passwordValidLabel
            ],
            axis: .vertical,
            spacing: Constants.elementStackViewSpacing,
            distribution: .fillProportionally
        )
        backgroundView.addSubview(elementStackView)

        buttonsStackView = UIStackView(
            arrangedSubviews: [createAccountButton, returnButton],
            axis: .horizontal,
            spacing: Constants.buttonStackViewSpacing,
            distribution: .fillEqually
        )

        backgroundView.addSubview(buttonsStackView)

        navigationItem.hidesBackButton = true

        firstNameValidLabel.textColor = .clear
        lastNameValidLabel.textColor = .clear
        ageValidLabel.textColor = .clear
        phoneValidLabel.textColor = .clear
        emailValidLabel.textColor = .clear
        passwordValidLabel.textColor = .clear
    }

    func changeColorUI(to currentUserInterfaceStyle: UIUserInterfaceStyle) {
        if currentUserInterfaceStyle == .dark {
            view.backgroundColor = .darkGray
        } else {
            view.backgroundColor = .white
        }
    }

    func addGesture() {
        let swipeGestureRecognizerRight = UISwipeGestureRecognizer(
            target: self,
            action: #selector(didSwipe(_:))
        )
        swipeGestureRecognizerRight.direction = .right
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didTap(_:))
        )
        backgroundView.addGestureRecognizer(swipeGestureRecognizerRight)
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
    }

    func setupDelegate() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    func checkFields(){
        if firstNameIsValid,
           lastNameIsValid,
           ageIsValid,
           phoneIsValid,
           emailIsValid,
           passwordIsValid {
            createAccountButton.isEnabled = true
        } else {
            createAccountButton.isEnabled = false
        }
    }

    func setTextFieldPhoneNumber(
        textField: UITextField,
        pattern: String,
        replacementCharacter: Character,
        string: String,
        range: NSRange
    ) {
        let text = (textField.text ?? "") + string
        var resultString: String
        
        if range.length == 1 {
            let end = text.index(text.startIndex, offsetBy: text.count - 1)
            resultString = String(text[text.startIndex..<end])
        }
        else {
            resultString = text.applyPatternOnNumbers(
                pattern: pattern,
                replacementCharacter: replacementCharacter
            )
        }

        if resultString.count > 1 {
            let indexOfFirstDigit = resultString.index(resultString.startIndex, offsetBy: 1)
            let currentSymbol = resultString[indexOfFirstDigit]
            if currentSymbol == Constants.firstSymbolEight {
                resultString.remove(at: indexOfFirstDigit)
                resultString.insert(
                    Constants.firstSymbolSeven,
                    at: indexOfFirstDigit
                )
            } else if currentSymbol != Constants.firstSymbolEight, currentSymbol != Constants.firstSymbolSeven {
                resultString.insert("(", at: indexOfFirstDigit)
                resultString.insert(
                    Constants.firstSymbolSeven,
                    at: indexOfFirstDigit
                )
            }
        }

        // Trim extra numbers
        if resultString.count > pattern.count {
            let end = resultString.index(resultString.startIndex, offsetBy: pattern.count)
            resultString = String(resultString[resultString.startIndex..<end])
            textField.text = resultString
        }
        else {textField.text = resultString}
    }

    func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: guide.topAnchor,
                constant: Constants.scrollViewTopAnchor
            ),
            scrollView.leadingAnchor.constraint(
                equalTo: guide.leadingAnchor,
                constant: Constants.scrollViewLeadingAnchor
            ),
            scrollView.trailingAnchor.constraint(
                equalTo: guide.trailingAnchor,
                constant: Constants.scrollViewTrailingAnchor
            ),
            scrollView.bottomAnchor.constraint(
                equalTo: guide.bottomAnchor,
                constant: Constants.scrollViewBottomAnchor
            )
        ])

        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            backgroundView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(
                equalTo: backgroundView.topAnchor,
                constant: Constants.loginLabelTopAnchor
            ),
            loginLabel.centerXAnchor.constraint(
                equalTo: backgroundView.centerXAnchor
            )
        ])

        NSLayoutConstraint.activate([
            elementStackView.topAnchor.constraint(
                equalTo: loginLabel.bottomAnchor,
                constant: Constants.elementStackViewTopAnchor
            ),
            elementStackView.centerXAnchor.constraint(
                equalTo: backgroundView.centerXAnchor
            ),
            elementStackView.leadingAnchor.constraint(
                equalTo: backgroundView.leadingAnchor,
                constant: Constants.elementStackViewLeadingAnchor
            ),
            elementStackView.trailingAnchor.constraint(
                equalTo: backgroundView.trailingAnchor,
                constant: Constants.elementStackViewTrailingAnchor
            )
        ])

        NSLayoutConstraint.activate([
            createAccountButton.heightAnchor.constraint(
                equalToConstant: Constants.createAccountButtonHeightAnchor
            ),
            returnButton.heightAnchor.constraint(
                equalToConstant: Constants.returnButtonHeightAnchor
            )
        ])

        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(
                equalTo: elementStackView.bottomAnchor,
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
// MARK: - Constants

extension SignUpViewController {
    private enum Constants {
        // MARK: UI constants

        static let loginLabelText = "Registration"

        static let firstNameTextFieldTag = 1
        static let firstNameTextFieldPlaceholder = "First Name"
        static let firstNameFontSize: CGFloat = 16

        static let phoneTextFieldTag = 3
        static let phoneTextFieldPlaceholder = "Phone"
        static let phoneFontSize: CGFloat = 16
        static let phonePattern = "+#(###)###-##-##"
        static let phoneReplacementCharacter: Character = "#"
        static let firstSymbolEight: Character = "8"
        static let firstSymbolSeven: Character = "7"

        static let lastNameTextFieldTag = 2
        static let lastNameTextFieldPlaceholder = "Last Name"
        static let lastNameFontSize: CGFloat = 16

        static let labelPlug = "Required field"

        static let ageFontSize: CGFloat = 16
        
        static let emailTextFieldTag = 4
        static let emailTextFieldPlaceholder = "E-mail"
        static let emailFontSize: CGFloat = 16

        static let passwordTextFieldTag = 5
        static let passwordTextFieldPlaceholder = "Password"
        static let passwordFontSize: CGFloat = 16

        static let elementStackViewSpacing: CGFloat = 10
        static let buttonStackViewSpacing: CGFloat = 10

        static let createAccountButtonTitle = "Create account"
        static let createAccountButtonCornerRadius: CGFloat = 10

        static let returnButtonTitle = "Back"
        static let returnButtonCornerRadius: CGFloat = 10

        static let succsessAlertTitle = "Congratulations!"
        static let failureAlertTitle = "Warning"
        static let buttonAlertTitle = "OK"
        
        // MARK: Constraint constants

        static let scrollViewTopAnchor: CGFloat = 0
        static let scrollViewLeadingAnchor: CGFloat = 0
        static let scrollViewTrailingAnchor: CGFloat = 0
        static let scrollViewBottomAnchor: CGFloat = 0

        static let loginLabelTopAnchor: CGFloat = 27

        static let elementStackViewTopAnchor: CGFloat = 10
        static let elementStackViewLeadingAnchor: CGFloat = 20
        static let elementStackViewTrailingAnchor: CGFloat = -20

        static let createAccountButtonHeightAnchor: CGFloat = 40
        static let returnButtonHeightAnchor: CGFloat = 40

        static let buttonsStackViewLeadingAnchor: CGFloat = 20
        static let buttonsStackViewTopAnchor: CGFloat = 30
        static let buttonsStackViewTrailingAnchor: CGFloat = -20
    }
}
