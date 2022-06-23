//
//  UserInfoModels.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 23.06.2022.
//

import Foundation

// VIP cycles
enum UserInfoModels {
    enum ShowPersonalDataUser {
        struct Request { }
        struct Response {
            let activeUser: User?
        }
        struct ViewModel {
            let firstName: String
            let lastName: String
            let ageString: String
            let phone: String
            let email: String
            let password: String
        }
    }
}
