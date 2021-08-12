//
//  APIHandler.swift
//  PersonalityTest
//
//  Created by Dragos Iancu on 05/01/2021.
//

import Alamofire
import Foundation

class ApiHandler {
    
    private var statusCode = Int.zero
    static var timeoutInterval = 30.0
    
    var sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        
        configuration.timeoutIntervalForRequest = ApiHandler.timeoutInterval
        configuration.waitsForConnectivity = true
        
        return Session(configuration: configuration, eventMonitors: [NetworkLogger()])
    }()
    
    /// Method used to send a GET request.
    /// The response will be received asynchronously in the completion handler and will be of the generic type inherited from the caller or error.
    /// - Parameters:
    ///   - convertible: `URLConvertible` value to be used as the `URLRequest`'s `URL`.
    ///   - parameters:  `Encodable` value to be encoded into the `URLRequest`. `nil` by default.
    ///   - completionHandler:  An escaping completion handler with a generic parameter of type `T` which will be used to deserialize a response into and an error, `nil` by default.
    func get<T: Decodable>(url: String,
                           parameters: [String: String]?,
                           completionHandler: @escaping (_ response: T?, _ error: ErrorModel?) -> Void){
        sessionManager.request(url,
                               method: .get,
                               parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { response in
                guard response.data != nil else {
                    completionHandler(nil,nil)
                    print("Error: Response body is nil...")
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                switch response.result {
                case .success:
                    do {
                        let decodedResponse = try jsonDecoder.decode(T.self, from: response.data!)
                        completionHandler(decodedResponse, nil)
                    }catch {
                        print(error)
                        completionHandler(nil, nil)
                    }
                case .failure:
                    do {
                        let decodedError = try jsonDecoder.decode(ErrorModel.self, from: response.data!)
                        completionHandler(nil, decodedError)
                    } catch {
                        print(error)
                        completionHandler(nil, nil)
                    }
                }
            })
    }
    
    /// Method used to send a POST request.
    /// The response will be received asynchronously in the completion handler and will be of the generic type inherited from the caller or error.
    /// - Parameters:
    ///   - convertible: `URLConvertible` value to be used as the `URLRequest`'s `URL`.
    ///   - requestBody:  `Encodable` value to be encoded into the `URLRequest`. `nil` by default.
    ///   - completionHandler:  An escaping completion handler with a generic parameter of type `T` which will be used to deserialize a response into and an error, `nil` by default.
    func post<E: Encodable, T: Decodable>(url: String,
                                          requestBody: E?,
                                          completionHandler: @escaping (_ response: T?, _ error: ErrorModel?) -> Void){
        sessionManager.request(url,
                               method: .post,
                               parameters: requestBody,
                               encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { response in
                guard response.data != nil else {
                    completionHandler(nil,nil)
                    print("Error: Response body is nil...")
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                switch response.result {
                case .success:
                    do {
                        let decodedResponse = try jsonDecoder.decode(T.self, from: response.data!)
                        completionHandler(decodedResponse, nil)
                    } catch {
                        print(error)
                        completionHandler(nil, nil)
                    }
                case .failure:
                    do {
                        let decodedError = try jsonDecoder.decode(ErrorModel.self, from: response.data!)
                        completionHandler(nil, decodedError)
                    }catch {
                        print(error)
                        completionHandler(nil, nil)
                    }
                }
            })
    }
    
    /// Method used to send a POST request.
    /// The response will be received asynchronously in the completion handler and will be of the generic type inherited from the caller or error.
    /// - Parameters:
    ///   - convertible: `URLConvertible` value to be used as the `URLRequest`'s `URL`.
    ///   - requestBody:  `Encodable` value to be encoded into the `URLRequest`. `nil` by default.
    ///   - completionHandler:  An escaping completion handler with the request statusCode and an error, `nil` by default.
    func post<E: Encodable>(url: String,
                            requestBody: E?,
                            completionHandler: @escaping (_ statusCode: Int, _ error: ErrorModel?) -> Void){
        sessionManager.request(url,
                               method: .post,
                               parameters: requestBody,
                               encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { response in
                let jsonDecoder = JSONDecoder()
                switch response.result {
                case .success:
                    if let id = try? response.result.get() as? Int {
                        completionHandler(id, nil)
                    } else {
                        completionHandler(response.response?.statusCode ?? 0, nil)
                    }
                case .failure:
                    guard response.data != nil else {
                        completionHandler(response.response?.statusCode ?? 0,nil)
                        print("Error: Response body is nil...")
                        return
                    }
                    
                    do {
                        let decodedError = try jsonDecoder.decode(ErrorModel.self, from: response.data!)
                        completionHandler(response.response?.statusCode ?? 0, decodedError)
                    }catch {
                        print(error)
                        completionHandler(response.response?.statusCode ?? 0, nil)
                    }
                }
            })
    }
    
    func put<E: Encodable>(url: String,
                            requestBody: E?,
                            completionHandler: @escaping (_ statusCode: Int, _ error: ErrorModel?) -> Void){
        sessionManager.request(url,
                               method: .put,
                               parameters: requestBody,
                               encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { response in
                let jsonDecoder = JSONDecoder()
                switch response.result {
                case .success:
                    completionHandler(response.response?.statusCode ?? 0, nil)
                case .failure:
                    guard response.data != nil else {
                        completionHandler(response.response?.statusCode ?? 0,nil)
                        print("Error: Response body is nil...")
                        return
                    }
                    
                    do {
                        let decodedError = try jsonDecoder.decode(ErrorModel.self, from: response.data!)
                        completionHandler(response.response?.statusCode ?? 0, decodedError)
                    }catch {
                        print(error)
                        completionHandler(response.response?.statusCode ?? 0, nil)
                    }
                }
            })
    }
}

class NetworkLogger: EventMonitor {
    //1
    let queue = DispatchQueue(label: "alamofire.networklogger")
    
    //2
    func requestDidFinish(_ request: Request) {
        print("Request: \(request.description)")
    }
    
    //3
    func request<Value>(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Value, AFError>
    ) {
        guard let data = response.data else {
            return
        }
        
        if let json = try? JSONSerialization
            .jsonObject(with: data, options: .mutableContainers) {
            print(json)
        }
    }
}
