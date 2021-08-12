//
//  QuizzView.swift
//  PersonalityTest
//
//  Created by Dragos Iancu on 11.08.2021.
//

import SwiftUI

struct QuizzView: View {
    @StateObject var viewModel = QuizzViewModel()
    
    var body: some View {
        ZStack {
            VStack{
                ScrollView {
                    LazyHStack {
                        pageView
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.75)
                
                HStack{
                    Spacer()
                    
                    Button {
                        withAnimation {
                            viewModel.previousQuestion()
                        }
                    } label: {
                        HStack{
                            Image(systemName: "arrow.left")
                            Text("Previous")
                        }
                    }
                    .disabled(viewModel.currentQuestion == 0)
                    
                    Spacer()
                    
                    if(viewModel.questions.count == 0
                       || viewModel.currentQuestion < viewModel.questions.count - 1){
                        Button {
                            withAnimation {
                                viewModel.nextQuestion()
                            }
                        } label: {
                            HStack{
                                Text("Next")
                                Image(systemName: "arrow.right")
                            }
                        }
                        .disabled(viewModel.questions.count == 0)
                    }else{
                        Button {
                            withAnimation {
                                viewModel.finishButtonPressed()
                            }
                        } label: {
                            HStack{
                                Image(systemName: "checkmark")
                                Text("Finish")
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .onAppear(perform: {
                viewModel.retrieveQuestions()
            })
            
            //validation error pop-up
            PopUpWindow(title: "Opps",
                        message: "You must answer all questions to complete the test",
                        buttonText: "OK",
                        show: $viewModel.showError)
            
            //end results pop-up
            PopUpWindow(title: "Results 👑",
                        message: viewModel.resultMessage,
                        buttonText: "OK",
                        show: $viewModel.showResults)
        }
    }
    
    var pageView: some View {
        TabView(selection: $viewModel.currentQuestion, content: {
            ForEach(0 ..< viewModel.questions.count, id: \.self) { i in
                ZStack {
                    Color.white
                    QuestionView(viewModel: viewModel.questionsViewModels[i])
                }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                .shadow(radius: 1)
            }
            .padding(.all, 10)
        })
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.7)
        .tabViewStyle(PageTabViewStyle())
        
    }
}
