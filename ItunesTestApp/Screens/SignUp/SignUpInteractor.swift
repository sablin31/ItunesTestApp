//
//  SignUpInteractor.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 14.06.2022.
//

import Foundation

protocol SignUpBusinessLogic: AnyObject {
    var presenter: SignUpPresentationLogic? { get set }

    func validateTextField(request: SignUpModels.ValidateTextFields.Request)
    func validateAge(request: SignUpModels.ValidateAge.Request)
    func validatePhone(request: SignUpModels.ValidatePhone.Request)
    func registrationUser(request: SignUpModels.RegistrationUser.Request)
}

class SignUpInteractor: SignUpBusinessLogic {
    // MARK: - Public properties

    var presenter: SignUpPresentationLogic?
    // MARK: - Public  methods

    func validateTextField(request: SignUpModels.ValidateTextFields.Request) {
        let fieldIsValid = request.field.isValid(validType: request.validTypes) ?
        true : false

        let response = SignUpModels.ValidateTextFields.Response(
            fieldIsValid: fieldIsValid, tag: request.tag
        )
        presenter?.presentValidateResultTextField(responce: response)
    }

    func validateAge(request: SignUpModels.ValidateAge.Request) {
        var ageIsValid = false
        let calendar = NSCalendar.current
        let dateNow = Date()

        let age = calendar.dateComponents([.year], from: request.bightday, to: dateNow)
        let ageYear = age.year
        if let ageUser = ageYear, ageUser >= Constants.ageLimit {
            ageIsValid = true
        }

        let responce = SignUpModels.ValidateAge.Response(ageIsValid: ageIsValid)
        presenter?.presentValidateResultAge(responce: responce)
    }

    func validatePhone(request: SignUpModels.ValidatePhone.Request) {
        var phoneNumberIsValid = false

        phoneNumberIsValid = request.phoneNumber.count == request.pattern.count ? true : false
        let responce = SignUpModels.ValidatePhone.Response(phoneIsValid: phoneNumberIsValid)
        presenter?.presentValidateResultPhone(responce: responce)
    }

    func registrationUser(request: SignUpModels.RegistrationUser.Request) {
        let status: RegistationStatus

        let firstNameIsValid = request.firstName.isValid(validType: .name)
        let lastNameIsValid = request.lastName.isValid(validType: .name)
        var ageIsValid = false
        let calendar = NSCalendar.current
        let dateNow = Date()
        let ageRequest = calendar.dateComponents([.year], from: request.age, to: dateNow)
        let ageYear = ageRequest.year
        if let userAge = ageYear, userAge >= Constants.ageLimit {
            ageIsValid = true
        }
        let emailIsValid = request.email.isValid(validType: .email)
        let passwordIsValid = request.password.isValid(validType: .password)

        if firstNameIsValid,
            lastNameIsValid,
            ageIsValid,
            emailIsValid,
            passwordIsValid
        {
            let firstName = request.firstName
            let lastName = request.lastName
            let age = request.age
            let phone = request.phone
            let email = request.email.lowercased()
            let password = request.password
            // Save user in UserBase
            if WorkerStorage.shared.saveUser(
                firstName: firstName,
                lastName: lastName,
                phone: phone,
                email: email,
                password: password,
                age: age
            ) { status = .succsess }
            else { status = .userAlreadyExist }
        } else { status = .notCorrectRegData }

        let responce = SignUpModels.RegistrationUser.Response(status: status)
        presenter?.presentResultRegistation(responce: responce)
    }
}
// MARK: - Constants

extension SignUpInteractor {
    private enum Constants {
        static let ageLimit = 18
    }
}
