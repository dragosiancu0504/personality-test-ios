//
//  QuestionsViewModel.swift
//  PersonalityTest
//
//  Created by Dragos Iancu on 11.08.2021.
//

import Foundation

class QuizzViewModel: ObservableObject {
    
    @Published var questions = [QuestionModel]()
    @Published var currentQuestion = 0
    @Published var questionsViewModels = [QuestionViewModel]()
    
    @Published var showError = false
    
    @Published var showResults = false
    @Published var resultMessage = ""
    
    var questionsHandler = QuestionsHandler.shared
    
    func nextQuestion() {
        if currentQuestion < questions.count - 1 {
            currentQuestion += 1
        }
    }
    
    func previousQuestion(){
        if currentQuestion > 0 {
            currentQuestion -= 1
        }
    }
    
    func finishButtonPressed(){
        //validate results
        let allQuestionsAnswered = questionsViewModels.reduce(true) { res, qvm in
            res && qvm.currentSelection >= 0
        }
        if !allQuestionsAnswered {
            showError = true
            return
        }
        
        //gather results
        var introScore = 0
        var extroScore = 0
        for questionViewModel in questionsViewModels {
            introScore += questionViewModel.question.answers[questionViewModel.currentSelection].introScore
            extroScore += questionViewModel.question.answers[questionViewModel.currentSelection].extroScore
        }
        let introPercentage = introScore / questions.count * 10
        let extroPercentage = extroScore / questions.count * 10
        
        resultMessage = "You are \(introPercentage)% Introvert and \(extroPercentage)% Extrovert"
        
        showResults.toggle()
    }
    
    func retrieveQuestions() {
        questionsHandler.getQuestions {[weak self] resp in
            
            //create question view models
            self?.questionsViewModels = [QuestionViewModel]()
            for question in resp {
                self?.questionsViewModels.append(QuestionViewModel(question: question))
            }
            
            //assign and notify of data source change
            self?.questions = resp
        }
    }
}
