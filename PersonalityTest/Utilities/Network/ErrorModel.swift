//
//  ErrorModel.swift
//  PersonalityTest
//
//  Created by Dragos Iancu on 02/02/2021.
//

import Foundation

class ErrorModel: ObservableObject, Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case Detail, Message, Validation
    }
    
    var Detail: String?
    var Message: String = ""
    var Validation: [String]? = []
    
    init(){}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        Detail = try container.decodeIfPresent(String.self, forKey: .Detail)
        Message = try container.decode(String.self, forKey: .Message)
        Validation = try container.decode([String].self, forKey: .Validation)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(Detail, forKey: .Detail)
        try container.encode(Message, forKey: .Message)
        try container.encode([Validation], forKey: .Validation)
    }
    
    func getValidationMessages() -> String {
        
        var validationValue: String = ""
        if (Validation != nil || Validation!.count > 0){
            validationValue = Validation!.first!
        } else  {
            return ""
        }
        return validationValue
    }
}
