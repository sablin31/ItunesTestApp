//
//  AuthorizationModels.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 12.06.2022.
//

import Foundation

// VIP cycles
enum AuthorizationModels {
    // MARK: Check user
    enum CheckUser {
        struct Request {
            let login: String
            let password: String
        }
        struct Response {
            let resultAuthorization: Bool
            let descriptionOperation: DescriptionAuthorization
        }
        struct ViewModel {
            let resultAuthorization: Bool
            let descriptionOperation: String
        }
    }
}

enum DescriptionAuthorization {
    case success
    case fieldsIsEmpty
    case notFoundUser
    case wrongPass
    case undefinedError
}
