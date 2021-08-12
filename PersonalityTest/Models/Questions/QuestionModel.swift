//
//  QuestionModel.swift
//  PersonalityTest
//
//  Created by Dragos Iancu on 11.08.2021.
//

import Foundation

struct QuestionModel: Decodable {
    var question: String
    var answers: [AnswerModel]
}
