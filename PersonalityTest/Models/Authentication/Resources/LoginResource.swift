//
//  LoginResource.swift
//  PersonalityTest
//
//  Created by Dragos Iancu on 06/01/2021.
//

import Foundation

struct LoginResource: Encodable {
    var username: String?
    var password: String?
 
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
