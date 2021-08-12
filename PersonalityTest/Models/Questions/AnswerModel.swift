//
//  AnswerModel.swift
//  PersonalityTest
//
//  Created by Dragos Iancu on 11.08.2021.
//

import Foundation

struct AnswerModel: Decodable {
    var name: String
    var introScore: Int
    var extroScore: Int
}
