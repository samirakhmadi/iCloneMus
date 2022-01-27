//
//  UserDefaultsManager.swift
//  ListAlbum
//
//  Created by Samir Akhmadi on 18.01.2022.
//

import Foundation

class DataBase {
    
    static let shared = DataBase()
    
    enum SettingsKeys: String {
        case users
        case activeUser
    }
    
    let defaults = UserDefaults.standard
    let userKey = SettingsKeys.users.rawValue
    let activeUserKey = SettingsKeys.activeUser.rawValue
    
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
                defaults.setValue(data, forKey: userKey)
            }
        }
    }
    
    func saveUser(firstName: String, secondName: String, phone: String, email: String, password: String, age: Date){
        let user = User(firstName: firstName, secondName: secondName, phone: phone, email: email, password: password, age: age)
        users.insert(user, at: 0)
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
                defaults.setValue(data, forKey: activeUserKey)
            }
        }
    }
    
    func setActiveUser(user: User) {
        activeUser = user
    }
    
    func removeActiveUser(){
        defaults.removeObject(forKey: activeUserKey)
    }
}
