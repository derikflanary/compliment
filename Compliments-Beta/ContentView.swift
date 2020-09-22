//
//  ContentView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 7/3/20.
//

import SwiftUI
//import StoreKit

struct ContentView: View {
    
    @State private var message: String = ""
    @State private var isComplete = false
    @State private var showDownloadPrompt = false
    @State private var selectedAnswer: Answer?
    private let potentialAnswers = [Answer(title: "Bronze", color: .orange), Answer(title: "Silver", color: .gray), Answer(title: "Gold", color: .yellow)]
    
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                VStack {
                    Text("compliment")
                        .font(.custom("Montserrat-Light", size: 36))
                        .padding(8)
                        .border(Color.appTintColor, width: 2)
                        .cornerRadius(4)
                        .foregroundColor(.appTintColor)
                        .padding(.top, 60)
                    
                    SuccessView(isComplete: $isComplete)
                    
                    Group {
                        QuestionView(question: Question(title: "Select an award level for this employee based on the service you received", answers: potentialAnswers), selectedAnswer: $selectedAnswer)
                            .padding(.top, 20)
                        
                        HStack {
                            Text("Tell us why? (optional)")
                                .font(.title3)
                            
                            Spacer()
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 8)
                        
                        TextEditor(text: $message)
                            .border(Color(.label), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            .cornerRadius(8)
                            .frame(height: 200)
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                isComplete = true
                                showDownloadPrompt = true
                                UIWindow.currentWindow?.endEditing(true)
                            }
                        }, label: {
                            Text("Submit")
                                .font(.headline)
                                .bold()
                                .foregroundColor(Color(.label))
                                .padding(.horizontal, 92)
                                .padding(.vertical, 16)
                                .border(Color(.label), width: 1)
                                .clipShape(Capsule())
                                .shadow(radius: 4)
                        })
                        .padding(.vertical, 32)
                        .disabled(selectedAnswer == nil)
                        .opacity(selectedAnswer == nil ? 0.2 : 1.0)
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
//        .appStoreOverlay(isPresented: $showDownloadPrompt) {
//            SKOverlay.AppConfiguration(appIdentifier: "1522177910", position: .bottom)
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
