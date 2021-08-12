//
//  LoginHandler.swift
//  PersonalityTest
//
//  Created by Dragos Iancu on 05/01/2021.
//


import Combine
import Alamofire

class AuthHandler: ApiHandler, ObservableObject {
    
    static let shared = AuthHandler()
    
    @Published var token = TokenManager.shared.fetchAccessToken() ?? ""
    @Published var isLoading = false
    
    private override init(){}
    
    func loginApiCall(loginResource: LoginResource?) {
        isLoading = true
        
        self.post(url: ApiRoutes.loginUrl,
                  requestBody: loginResource){[weak self] (response: LoginResponse?, error: ErrorModel?) in
            self?.isLoading = false
            
            if let unwrappedResponse = response {
                self?.token = unwrappedResponse.token
                
                //save the session token for future uses
                TokenManager.shared.saveAccessToken(token: unwrappedResponse.token)
            }else{
                self?.token = ""
            }
        }
    }
    
    //logic for logging out the user
    func logout(){
        self.token = ""
        TokenManager.shared.clearAccessToken()
    }
    
    
}
