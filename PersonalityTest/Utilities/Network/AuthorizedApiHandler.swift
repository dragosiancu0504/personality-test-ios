//
//  AuthorizedApiHandler.swift
//  PersonalityTest
//
//  Created by Dragos Iancu on 06/01/2021.
//

import Alamofire
import Foundation

class AuthorizedApiHandler: ApiHandler {
    
    override init() {
        super.init()
        
        self.sessionManager = {
            let configuration = URLSessionConfiguration.af.default
            configuration.timeoutIntervalForRequest = ApiHandler.timeoutInterval
            configuration.waitsForConnectivity = true
            return Session(configuration: configuration,
                           interceptor: AuthorizedRequestInterceptor(),
                           eventMonitors: [NetworkLogger()])
        }()
    }
}

class AuthorizedRequestInterceptor: RequestInterceptor {
    let retryLimit = 5
    let retryDelay: TimeInterval = 10
    
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let token = TokenManager.shared.fetchAccessToken() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        let response = request.task?.response as? HTTPURLResponse
        //Retry for 5xx status codes
        if let statusCode = response?.statusCode,
            (500...599).contains(statusCode),
            request.retryCount < retryLimit {
            completion(.retryWithDelay(retryDelay))
        } else {
            return completion(.doNotRetry)
        }
    }
}
