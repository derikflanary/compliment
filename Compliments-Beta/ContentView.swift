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
    private let potentialAnswers = [Answer(title: "Bronze", color: .orange), Answer(title: "Silver", color: .gray), Answer(title: "Gold", color: .yellow)]
    
    
    var body: some View {
        ScrollView {
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
                        QuestionView(question: Question(title: "Select an award level for this employee based on the service you received", answers: potentialAnswers))
                        
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
                                showDownloadPrompt = true
                                UIWindow.currentWindow?.endEditing(true)
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
                        .disabled(message.isEmpty)
                        .opacity(message.isEmpty ? 0.2 : 1.0)
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
