//
//  User.swift
//  ListAlbum
//
//  Created by Samir Akhmadi on 18.01.2022.
//

import Foundation

struct User: Codable {
    let firstName: String
    let secondName: String
    let phone: String
    let email: String
    let password: String
    let age: Date
}
