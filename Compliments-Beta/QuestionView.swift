//
//  QuestionView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 7/3/20.
//

import SwiftUI

struct QuestionView: View {
    
    let question: Question
    @State private var selectedAnswer: Answer?
    
    
    var body: some View {
        VStack {
            HStack {
                Text(question.title)
                    .font(.title3)
                
                Spacer()
            }
            .padding(.top, 40)
            .padding(.bottom, 8)
    
            HStack {
                ForEach(question.answers) { answer in
                    VStack {
                        CircleButton(isSelected: answer == selectedAnswer, title: answer.title) {
                            withAnimation {
                                self.selectedAnswer = answer
                            }
                        }
                    }
                    if answer != question.answers.last {
                        Spacer()
                    }
                }
                
            }
        }
    }
    
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(question: Question(title: "The service provided was", answers: [Answer(title: "Alright"), Answer(title: "Great"), Answer(title: "Amazing")]))
    }
}
