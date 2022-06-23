//
//  SignUpPresenter.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 14.06.2022.
//

import Foundation

protocol SignUpPresentationLogic: AnyObject {
    var viewController: SignUpDisplayLogic? { get set }

    func presentValidateResultTextField(responce: SignUpModels.ValidateTextFields.Response)
    func presentValidateResultAge(responce: SignUpModels.ValidateAge.Response)
    func presentValidateResultPhone(responce: SignUpModels.ValidatePhone.Response)
    func presentResultRegistation(responce: SignUpModels.RegistrationUser.Response)
}

final class SignUpPresenter: SignUpPresentationLogic {
    // MARK: - Public proterties

    weak var viewController: SignUpDisplayLogic?
    // MARK: - Public methods

    func presentValidateResultTextField(responce: SignUpModels.ValidateTextFields.Response) {
        var resultIsValidLabel: String

        if responce.fieldIsValid {
            switch (responce.tag) {
            case Constants.firstNameTextFieldTag:
                resultIsValidLabel = Constants.firstNameIsValidLabel
            case Constants.lastNameTextFieldTag:
                resultIsValidLabel = Constants.lastNameIsValidLabel
            case Constants.emailTextFieldTag:
                resultIsValidLabel = Constants.emailIsValidLabel
            case Constants.passwordTextFieldTag:
                resultIsValidLabel = Constants.passwordIsValidLabel
            default:
                resultIsValidLabel = Constants.dataIsValidLabel
            }
        } else {
            switch (responce.tag) {
            case Constants.firstNameTextFieldTag, Constants.lastNameTextFieldTag:
                resultIsValidLabel = Constants.nameIsNotValidLabel
            case Constants.emailTextFieldTag:
                resultIsValidLabel = Constants.emailIsNotValidLabel
            case Constants.passwordTextFieldTag:
                resultIsValidLabel = Constants.passwordIsNotValidLabel
            default:
                resultIsValidLabel = Constants.dataIsNotValidLabel
            }
        }

        let viewModel = SignUpModels.ValidateTextFields.ViewModel(
            resultIsValidLabel: resultIsValidLabel,
            resultIsValid: responce.fieldIsValid,
            tag: responce.tag
        )
        viewController?.showResultValidationTextField(viewModel: viewModel)
    }

    func presentValidateResultAge(responce: SignUpModels.ValidateAge.Response) {
        let resultAgeIsValidLabel = responce.ageIsValid ?
        Constants.ageIsValidLabel : Constants.ageIsNotValidLabel
        
        let viewModel = SignUpModels.ValidateAge.ViewModel(
            resultAgeIsValidLabel: resultAgeIsValidLabel,
            resultAgeIsValid: responce.ageIsValid
        )
        viewController?.showResultValidationAge(viewModel: viewModel)
    }

    func presentValidateResultPhone(responce: SignUpModels.ValidatePhone.Response) {
        let resultPhoneIsValidLabel = responce.phoneIsValid ?
        Constants.phoneIsValidLabel : Constants.phoneIsNotValidLabel
        
        let viewModel = SignUpModels.ValidatePhone.ViewModel(
            resultPhoneIsValidLabel: resultPhoneIsValidLabel,
            resultPhoneIsValid: responce.phoneIsValid
        )
        viewController?.showResultValidationPhone(viewModel: viewModel)
    }

    func presentResultRegistation(responce: SignUpModels.RegistrationUser.Response) {
        let status = responce.status
        let description: String
        
        switch status {
        case .succsess:
            description = Constants.succsessRegistationMessage
        case .userAlreadyExist:
            description = Constants.userAlreadyExistMessage
        case .notCorrectRegData:
            description = Constants.notCorrectRegDataMessage
        }
        
        let viewModel = SignUpModels.RegistrationUser.ViewModel(
            status: responce.status,
            description: description
        )
        viewController?.showResultRegistration(viewModel: viewModel)
    }
}
// MARK: - Constants

extension SignUpPresenter {
    private enum Constants {
        static let firstNameTextFieldTag = 1
        static let lastNameTextFieldTag = 2
        static let phoneTextFieldTag = 3
        static let emailTextFieldTag = 4
        static let passwordTextFieldTag = 5

        static let firstNameIsValidLabel = "First name is valid"
        static let lastNameIsValidLabel = "Last name is valid"
        static let nameIsNotValidLabel = "Only A-Z, min 1 character"
        static let ageIsValidLabel = "Age is valid"
        static let ageIsNotValidLabel = "Age must be over 18"
        static let phoneIsValidLabel = "Phone number is valid"
        static let phoneIsNotValidLabel = "Phone number is not valid"
        static let emailIsValidLabel = "E-mail is valid"
        static let emailIsNotValidLabel = "E-mail is not valid"
        static let passwordIsValidLabel = "Password is valid"
        static let passwordIsNotValidLabel = "Min 6 ch., must A-Z and a-z and 0-9"
        static let dataIsValidLabel = "Data is correct"
        static let dataIsNotValidLabel = "Data is filled incorrect"
        
        static let succsessRegistationMessage = "Registration is successfully! Please Log In!"
        static let userAlreadyExistMessage = "User in this e-mail already exist!"
        static let notCorrectRegDataMessage = "Registration is not complete! Please check all fields!"
    }
}
