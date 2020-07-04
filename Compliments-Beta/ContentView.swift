//
//  ContentView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 7/3/20.
//

import SwiftUI

struct ContentView: View {
    
    @State private var message: String = ""
    @State private var isComplete = false
    private let potentialAnswers = [Answer(title: "Alright"), Answer(title: "Great"), Answer(title: "Amazing")]
    
    
    var body: some View {
        ScrollView {
            HStack {
                VStack {
                    Text("compliments")
                        .font(.custom("Montserrat-Light", size: 36))
                        .padding(8)
                        .border(Color.appTintColor, width: 2)
                        .cornerRadius(4)
                        .foregroundColor(.appTintColor)
                        .padding(.top, 60)
                    
                    SuccessView(isComplete: $isComplete)
                    
                    Group {
                        QuestionView(question: Question(title: "This Employee was", answers: potentialAnswers))
                        
                        QuestionView(question: Question(title: "The service provided was", answers: potentialAnswers))
                        
                        HStack {
                            Text("Why do you feel this way?")
                                .font(.title3)
                            
                            Spacer()
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 8)
                        
                        TextEditor(text: $message)
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            .cornerRadius(8)
                            .frame(height: 200)
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                isComplete = true
                            }
                        }, label: {
                            Text("Submit")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.horizontal, 92)
                                .padding(.vertical, 16)
                                .background(Color.appTintColor)
                                .clipShape(Capsule())
                        })
                        .padding(.vertical, 32)
                    }.opacity(isComplete ? 0.0 : 1)
                
                    
                    Spacer()
                }
                .padding(.horizontal, 40)
            }
        }
        .keyboardAdaptive()
        .onTapGesture {
            UIWindow.currentWindow?.endEditing(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
