//
//  SingUpViewController.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 29.01.2022.
//

import UIKit

class SingUpViewController: UIViewController {
    
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
        label.text = "Registration"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "First Name"
        return textField
    }()
    
    private let firstNameValidLabel: UILabel = {
        let label = UILabel()
        label.text = "Required field"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Last Name"
        return textField
    }()
    
    private let lastNameValidLabel: UILabel = {
        let label = UILabel()
        label.text = "Required field"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageValidLabel: UILabel = {
        let label = UILabel()
        label.text = "Required field"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Phone"
        textField.keyboardType = .numberPad
        textField.addReturnToolbar(onReturn: (target: self, action: #selector(tapReturnDigitalKeyboard)))
        return textField
    }()
    
    private let phoneValidLabel: UILabel = {
        let label = UILabel()
        label.text = "Required field"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "E-mail"
        return textField
    }()
    
    private let emailValidLabel: UILabel = {
        let label = UILabel()
        label.text = "Required field"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        return textField
    }()
    
    private let passwordValidLabel: UILabel = {
        let label = UILabel()
        label.text = "Required field"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .brown
        button.setTitle("Create account", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let returnButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gray
        button.setTitle("Return", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // create the alert
    private let alertSuccsess = UIAlertController(title: "Congratulation", message: "Registration is succsessfuly! Please Log In!", preferredStyle: UIAlertController.Style.alert)
    
    // create the alert
    private let alertFailure = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
    
    private var elementStackView = UIStackView()
    private var buttonsStackView = UIStackView()
    private let datePicker = UIDatePicker()
    
    // Check constant valid fields
    private var firstNameIsValid = false
    private var lastNameIsValid = false
    private var ageIsValid = false
    private var phoneIsValid = false
    private var emailIsValid = false
    private var passwordIsValid = false
    
    deinit {
        removeKeyboardNotification()
        removeDarkModeNotification()
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(loginLabel)
        
        elementStackView = UIStackView(arrangedSubviews: [firstNameTextField,
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
                                                          passwordValidLabel],
                                       axis: .vertical,
                                       spacing: 10,
                                       distribution: .fillProportionally)
        backgroundView.addSubview(elementStackView)
        
        buttonsStackView = UIStackView(arrangedSubviews: [createAccountButton, returnButton],
                                       axis: .horizontal,
                                       spacing: 10,
                                       distribution: .fillEqually)
        backgroundView.addSubview(buttonsStackView)
        firstNameValidLabel.textColor = .clear
        lastNameValidLabel.textColor = .clear
        ageValidLabel.textColor = .clear
        phoneValidLabel.textColor = .clear
        emailValidLabel.textColor = .clear
        passwordValidLabel.textColor = .clear
        checkColorTheme()
    }
    
    let nameValidType: String.ValidTypes = .name
    let emailValidType: String.ValidTypes = .email
    let passwordValidType: String.ValidTypes = .password
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setConstraints()
        setupDelegate()
        setupDatePicker()
        registerKeyboardNotification()
        registerDarkModeNotification()
        // Initialize Swipe Gesture Recognizer
        let swipeGestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        // Configure Swipe Gesture Recognizer
        swipeGestureRecognizerRight.direction = .right
        backgroundView.addGestureRecognizer(swipeGestureRecognizerRight)
        alertFailure.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkColorTheme()
        navigationController?.setNavigationBarHidden(true, animated: animated)
        AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }
    
    private func setupDelegate() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.clipsToBounds = false
        datePicker.tintColor = .black
        datePicker.contentHorizontalAlignment = .left
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
    }
    
    //MARK: - Set TextField check Value
    private func setTextField(textField: UITextField, label: UILabel, validType: String.ValidTypes,validMessage: String, wrongMessage: String, string: String, range: NSRange) -> Bool{
        let text = (textField.text ?? "") + string
        let resultString: String
        var result = false
        
        if range.length == 1 {
            let end = text.index(text.startIndex, offsetBy: text.count - 1)
            resultString = String(text[text.startIndex..<end])
        } else {
            resultString = text
        }
        
        textField.text = resultString
        
        if resultString.isValid(validType: validType) {
            label.text = validMessage
            label.textColor = .green
            result = true
        } else {
            label.text = wrongMessage
            label.textColor = .red
            result = false
        }
        
        return result
    }
    
    //MARK: - Set TextField check Value phone number
    
    private func setTextFieldPhoneNumber(textField: UITextField, label: UILabel, pattern: String, replacementCharacter: Character, validMessage: String, wrongMessage: String, string: String, range: NSRange) -> Bool {
        let text = (textField.text ?? "") + string
        var resultString: String
        var result = false
        
        if range.length == 1 {
            let end = text.index(text.startIndex, offsetBy: text.count - 1)
            resultString = String(text[text.startIndex..<end])
        }
        else {
            resultString = text.applyPatternOnNumbers(pattern: pattern, replacementCharacter: replacementCharacter)
        }
        // Check first digit - If 8 and Russian Location - Replace +7
        if resultString.count > 1 {
            let indexOfFirstDigit = resultString.index(resultString.startIndex, offsetBy: 1)
            if resultString[indexOfFirstDigit] == "8" { //&& Locale.current.isRussian{
                resultString.remove(at: indexOfFirstDigit)
                resultString.insert("7", at: indexOfFirstDigit)
            }
        }
        
        // Trim extra numbers
        if resultString.count > pattern.count {
            let end = resultString.index(resultString.startIndex, offsetBy: pattern.count)
            resultString = String(resultString[resultString.startIndex..<end])
            textField.text = resultString
        }
        else {textField.text = resultString}
        
        // Check validation number
        if resultString.count == pattern.count {
            label.text = validMessage
            label.textColor = .green
            result = true
        } else {
            label.text = wrongMessage
            label.textColor = .red
            result = false
        }
        return result
    }
}


//MARK: - UITextFieldDelegate

extension SingUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case firstNameTextField:
            firstNameIsValid = setTextField(textField: firstNameTextField,
                                            label: firstNameValidLabel,
                                            validType: nameValidType,
                                            validMessage: "First name is valid",
                                            wrongMessage: "Only A-Z, min 1 character ",
                                            string: string,
                                            range: range)
        case lastNameTextField:
            lastNameIsValid = setTextField(textField: lastNameTextField,
                                           label: lastNameValidLabel,
                                           validType: nameValidType,
                                           validMessage: "Last name is valid",
                                           wrongMessage: "Only A-Z, min 1 character",
                                           string: string,
                                           range: range)
        case emailTextField:
            emailIsValid = setTextField(textField: emailTextField,
                                        label: emailValidLabel,
                                        validType: emailValidType,
                                        validMessage: "E-mail is valid",
                                        wrongMessage: "E-mail is not valid",
                                        string: string,
                                        range: range)
        case passwordTextField:
            passwordIsValid = setTextField(textField: passwordTextField,
                                           label: passwordValidLabel,
                                           validType: passwordValidType,
                                           validMessage: "Password is valid",
                                           wrongMessage: "Min 6 ch., must A-Z and a-z and 0-9",
                                           string: string,
                                           range: range)
        case phoneNumberTextField:
            phoneIsValid = setTextFieldPhoneNumber(textField: phoneNumberTextField,
                                                   label: phoneValidLabel,
                                                   pattern: "+#(###)###-##-##",
                                                   replacementCharacter: "#",
                                                   validMessage: "Phone number is valid",
                                                   wrongMessage: "Phone number is invalid",
                                                   string: string,
                                                   range: range)
        default:
            break
        }
        return false
    }
    
    private func checkAgeIsValid() -> Bool {
        let calendar = NSCalendar.current
        let dateNow = Date()
        let birthday = datePicker.date
        
        let age = calendar.dateComponents([.year], from: birthday, to: dateNow)
        let ageYear = age.year
        guard let ageUser = ageYear else {return false}
        return (ageUser < 18 ? false : true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    @objc private func createAccountButtonTapped(){
        
        if firstNameIsValid, lastNameIsValid, ageIsValid, phoneIsValid, emailIsValid, passwordIsValid {
            // Get all value TextField
            let firstNameText = firstNameTextField.text!
            let lastNameText = lastNameTextField.text!
            let age = datePicker.date
            let phoneNumberText = phoneNumberTextField.text!
            let emailText = emailTextField.text!.lowercased()
            let passwordText = passwordTextField.text!
            // Save user in UserBase
            if DataUsers.shared.saveUser(firstName: firstNameText,
                                         lastName: lastNameText,
                                         phone: phoneNumberText,
                                         email: emailText,
                                         password: passwordText,
                                         age: age) {
                alertSuccsess.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in self.navigationController?.popToRootViewController(animated: true) }))
                self.present(alertSuccsess, animated: true, completion: nil)
            } else {
                alertFailure.title = "Warning"
                alertFailure.message = "User in this e-mail already exist"
                self.present(alertFailure, animated: true, completion: nil)
            }
        } else {
            alertFailure.title = "Warning"
            alertFailure.message = "Registration is not complete! Please check all fields!"
            self.present(alertFailure, animated: true, completion: nil)
        }
    }
    
    @objc private func returnButtonTapped(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func tapReturnDigitalKeyboard() {
        phoneNumberTextField.resignFirstResponder()
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        let checkDate = checkAgeIsValid()
        if checkDate {
            ageValidLabel.text = "Age is valid"
            ageValidLabel.textColor = .green
            ageIsValid = true
        }
        else {
            ageValidLabel.text = "Age must be over 18"
            ageValidLabel.textColor = .red
            ageIsValid = false
        }
    }
    
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        returnButtonTapped()
    }
}

//MARK: - Keyboard Show Hide

extension SingUpViewController {
    
    private func registerKeyboardNotification(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardHeight = (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        if emailTextField.isFirstResponder || passwordTextField.isFirstResponder {
            scrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight.height / 2)
        } else { scrollView.contentOffset = CGPoint.zero}
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
}
//MARK: - SetConstraints

extension SingUpViewController {
    private func setConstraints() {
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 0),
                scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 0),
                scrollView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0),
                scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 0)
            ])
        } else {
            NSLayoutConstraint.activate([
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            ])
        }
        
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            backgroundView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loginLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            elementStackView.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 10),
            elementStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            elementStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            elementStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20)
        ])
        
        
        NSLayoutConstraint.activate([
            createAccountButton.heightAnchor.constraint(equalToConstant: 40),
            returnButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            buttonsStackView.topAnchor.constraint(equalTo: elementStackView.bottomAnchor, constant: 30),
            buttonsStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20)
        ])
    }
}

//MARK: - Button Hide in digital keyboard on UITextField
extension UITextField {
    func addReturnToolbar(onReturn: (target: Any, action: Selector)? = nil) {
        let onReturn = onReturn ?? (target: self, action: #selector(returnButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Return", style: .done, target: onReturn.target, action: onReturn.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func returnButtonTapped() { self.resignFirstResponder() }
}
//MARK: - Switch color on Darkmode
extension SingUpViewController {
    private func registerDarkModeNotification(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkColorTheme),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    private func removeDarkModeNotification(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func checkColorTheme()
    {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                self.view.backgroundColor = .black
            }
            else {
                self.view.backgroundColor = .white
            }
        }
    }
}
