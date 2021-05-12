//
//  QuestionView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 7/3/20.
//

import SwiftUI

struct QuestionView: View {

    // MARK: - Binding
    
    @Binding var selectedAnswer: Answer?
    
    
    // MARK: - Properties
    
    let question: Question
    
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            HStack {
                Text("Select an award level for this employee based on the service you received")
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .padding(.bottom, 8)
            .padding(.leading, 2)
    
            HStack {
                ForEach(question.answers) { answer in
                    StarButton(isSelected: answer == selectedAnswer, title: answer.title, color: answer.color) {
                        withAnimation(Animation.spring(dampingFraction: 0.5).speed(1.5)) {
                            self.selectedAnswer = answer
                            UIImpactFeedbackGenerator().impactOccurred()
                        }
                    }
                    if answer != question.answers.last {
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
}


// MARK: - Previews

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(selectedAnswer: .constant(nil), question: Question(title: "The service provided was", answers: [Answer(title: "Alright", color: .orange, value: 1), Answer(title: "Great", color: .gray, value: 2), Answer(title: "Amazing", color: .yellow, value: 3)]))
    }
}
