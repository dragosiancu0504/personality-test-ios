//
//  QuestionsHandler.swift
//  PersonalityTest
//
//  Created by Dragos Iancu on 11.08.2021.
//

import Combine
import Alamofire

class QuestionsHandler: ApiHandler, ObservableObject {
    
    static let shared = QuestionsHandler()
    
    private override init(){}
    
    func getQuestions(completionHandler: @escaping (_ questions: [QuestionModel]) -> Void) {
        self.get(url: ApiRoutes.questionsUrl, parameters: nil) { (questions: [QuestionModel]?, error: ErrorModel?) in
            if let unwrappedQuestions = questions {
                completionHandler(unwrappedQuestions)
            } else{
                completionHandler([])
            }
        }
    }
    

    
    
}
