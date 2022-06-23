//
//  UserDefaultsManager.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 08.02.2022.
//

import Foundation

class WorkerStorage {
    
    static let shared = WorkerStorage()
    
    enum SettingKeys: String {
        case users
        case activeUser
    }
    
    let defaults = UserDefaults.standard
    let userKey = SettingKeys.users.rawValue
    let activeUserKey = SettingKeys.activeUser.rawValue
    
    var users: [User] {
        get {
            if let data = defaults.value(forKey: userKey) as? Data {
                return try! PropertyListDecoder().decode([User].self, from: data)
            } else {
                return [User]()
            }
        }
        
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: userKey)
            }
        }
    }
    
    func saveUser(firstName: String, lastName: String, phone: String, email: String, password: String, age: Date) -> Bool {
        let user = User(firstName: firstName, lastName: lastName, phone: phone, email: email, password: password, age: age)
        let result = users.filter { $0.email == email }
        if result.isEmpty {
            users.insert(user, at: 0)
            return true
        } else {
            return false
        }
    }
    
    var activeUser: User? {
        get {
            if let data = defaults.value(forKey: activeUserKey) as? Data {
                return try! PropertyListDecoder().decode(User.self, from: data)
            } else {
                return nil
            }
        }
        
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: activeUserKey)
            }
        }
    }
    
    func saveActiveUser(user: User) {
        activeUser = user
    }
}

