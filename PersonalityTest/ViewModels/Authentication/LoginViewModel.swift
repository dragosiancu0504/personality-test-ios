//
//  LoginViewModel.swift
//  PersonalityTest
//
//  Created by Dragos Iancu on 05/01/2021.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject, Identifiable {
    
    @Published var username = "eve.holt@reqres.in"
    @Published var password = "cityslicka"
    
    @Published var isLoggedIn = false
    @Published var isLoading = false
    
    @Published var shouldNavigate = false
    
    private var disposables: Set<AnyCancellable> = []
    
    var authHandler = AuthHandler.shared
    
    @Published var token = ""
    
    private var isLoadingPublisher: AnyPublisher<Bool, Never> {
        authHandler.$isLoading
            .receive(on: RunLoop.main)
            .map { $0 }
            .eraseToAnyPublisher()
    }
    
    private var isAuthenticatedPublisher: AnyPublisher<String, Never> {
        authHandler.$token
            .receive(on: RunLoop.main)
            .map { $0 }
            .eraseToAnyPublisher()
    }
    
    init() {
        isLoadingPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &disposables)
        
        isAuthenticatedPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.token, on: self)
            .store(in: &disposables)
    }
    
    func login() {
        let loginResource = LoginResource(username: username, password: password)
        authHandler.loginApiCall(loginResource: loginResource)
    }
    
}
