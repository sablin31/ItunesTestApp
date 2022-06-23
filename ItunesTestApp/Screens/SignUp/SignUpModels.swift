//
//  SignUpModels.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 14.06.2022.
//

import Foundation

// VIP cycles
enum SignUpModels {
    enum ValidateTextFields {
        struct Request {
            let field: String
            let validTypes: String.ValidTypes
            let tag: Int
        }
        struct Response {
            let fieldIsValid: Bool
            let tag: Int
        }
        struct ViewModel {
            let resultIsValidLabel: String
            let resultIsValid: Bool
            let tag: Int
        }
    }

    enum ValidateAge {
        struct Request {
            let bightday: Date
        }
        struct Response {
            let ageIsValid: Bool
        }
        struct ViewModel {
            let resultAgeIsValidLabel: String
            let resultAgeIsValid: Bool
        }
    }

    enum ValidatePhone {
        struct Request {
            let phoneNumber: String
            let pattern: String
        }
        struct Response {
            let phoneIsValid: Bool
        }
        struct ViewModel {
            let resultPhoneIsValidLabel: String
            let resultPhoneIsValid: Bool
        }
    }

    enum RegistrationUser {
        struct Request {
            let firstName: String
            let lastName: String
            let age: Date
            let phone: String
            let email: String
            let password: String
        }
        struct Response {
            let status: RegistationStatus
        }
        struct ViewModel {
            let status: RegistationStatus
            let description: String
        }
    }
}

enum RegistationStatus {
    case succsess
    case userAlreadyExist
    case notCorrectRegData
}
