//
//  File.swift
//  PersonalityTest
//
//  Created by Dragos Iancu on 05/01/2021.
//

class RandomImageResponse: Decodable {
    
    var fileSizeBytes: Int?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case fileSizeBytes
        case url
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        fileSizeBytes = try? container.decode(Int.self, forKey: .fileSizeBytes)
        url = try? container.decode(String.self, forKey: .url)
    }
}
