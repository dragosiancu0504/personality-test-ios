//
//  TokenManager.swift
//  PersonalityTest
//
//  Created by Dragos Iancu on 06/01/2021.
//

import Foundation

class TokenManager {
    let userAccount = "accessToken"
    static let shared = TokenManager()
    
    private init(){}
    
    let secureStore: SecureStore = {
        let accessTokenQueryable = GenericPasswordQueryable(service: "TokenService")
        return SecureStore(secureStoreQueryable: accessTokenQueryable)
    }()
    
    func saveAccessToken(token: String) {
        do {
            try secureStore.setValue(token, for: userAccount)
        } catch let exception {
            print("Error saving access token: \(exception)")
        }
    }
    
    func fetchAccessToken() -> String? {
        do {
            return try secureStore.getValue(for: userAccount)
        } catch let exception {
            print("Error fetching access token: \(exception)")
        }
        return nil
    }
    
    func clearAccessToken() {
        do {
            return try secureStore.removeValue(for: userAccount)
        } catch let exception {
            print("Error clearing access token: \(exception)")
        }
    }
}
