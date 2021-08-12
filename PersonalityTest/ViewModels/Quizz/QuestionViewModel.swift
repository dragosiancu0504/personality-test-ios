//
//  QuestionViewModel.swift
//  PersonalityTest
//
//  Created by Dragos Iancu on 12.08.2021.
//

import Foundation

class QuestionViewModel: ObservableObject, Identifiable {
    @Published var question : QuestionModel
    @Published var currentSelection = -1
    
    init(question: QuestionModel) {
        self.question = question
    }

}
