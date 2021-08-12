//
//  QuestionView.swift
//  PersonalityTest
//
//  Created by Dragos Iancu on 12.08.2021.
//


import SwiftUI

struct QuestionView: View {
    @ObservedObject var viewModel : QuestionViewModel
    
    var body: some View {
        VStack{
            Spacer()
            Text(viewModel.question.question)
                .fontWeight(.semibold)
                .italic()
                .padding()
            ForEach(0..<viewModel.question.answers.count) { i in
                RadioButton(id: i, value: viewModel.question.answers[i].name, selectedID: $viewModel.currentSelection)
            }
            Spacer()
        }
    }
    
}
