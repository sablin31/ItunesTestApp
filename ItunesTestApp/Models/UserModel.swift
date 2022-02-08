//
//  UserModel.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 08.02.2022.
//

import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
    let phone: String
    let email: String
    let password: String
    let age: Date
}
