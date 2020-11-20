//
//  ContentView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 7/3/20.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    
    
    // MARK: - State Objects
    
    @StateObject var network = NetworkManager()
    
    
    // MARK: - State
    
    @State private var message: String = ""
    @State private var showDownloadPrompt = false
    @State private var selectedAnswer: Answer?
    
    
    // MARK: - Properties
    
    private let potentialAnswers = [Answer(title: "Bronze", color: .orange, value: 1), Answer(title: "Silver", color: .gray, value: 2), Answer(title: "Gold", color: .yellow, value: 3)]
    private let textViewId = "textViewId"
    private let textViewHeight: CGFloat = 200
    
    
    // MARK: - Body
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            
            ScrollView(showsIndicators: false) {
                HStack {
                    VStack {
                        Text("compliment")
                            .font(.system(size: 36, weight: .light, design: .default))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .foregroundColor(.appTintColor)
                            .cornerRadius(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.appTintColor, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                            )
                            .onTapGesture(count: 3, perform: {
                                network.isComplete = false
                            })
                        
                        if network.isComplete {
                            Spacer()
                            
                            SuccessView(isComplete: $network.isComplete)
                                .transition(.scale)
                                .padding(.top, 60)
                                .onAppear {
                                    showDownloadPrompt = true
                                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                                }
                        }
                        
                        Group {
                            QuestionView(selectedAnswer: $selectedAnswer, question: Question(title: "Select an award level for this employee based on the service you received", answers: potentialAnswers))
                                .padding(.top, 60)
                            
                            HStack {
                                Text("Tell us why? (optional)")
                                    .font(.title3)
                                
                                Spacer()
                            }
                            .padding(.top, 40)
                            .padding(.bottom, 8)
                            
                            TextEditor(text: $message)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(.label), lineWidth: 2)
                                )
                                .onTapGesture {
                                    delayOnMainThread(0.5) {
                                        withAnimation {
                                            scrollProxy.scrollTo(textViewId, anchor: .bottom)
                                        }
                                    }
                                }
                                .frame(height: textViewHeight)
                                .id(textViewId)
                            
                            Button(action: {
                                sendCompliment()
                            }, label: {
                                Text("Submit")
                                    .font(.headline)
                                    .bold()
                            })
                            .buttonStyle(ActionButtonStyle())
                            .padding(.vertical, 32)
                            .disabled(selectedAnswer == nil)
                            .opacity(selectedAnswer == nil ? 0.2 : 1.0)
                        }.opacity(network.isComplete ? 0.0 : 1)
                        
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical)
                }
            }
            .onTapGesture {
                UIWindow.currentWindow?.endEditing(true)
            }
        }
    }
    
    func sendCompliment() {
        UIWindow.currentWindow?.endEditing(true)
        guard let value = selectedAnswer?.value else { return }
        network.sendCompliment(with: 1, employerId: 2, comment: message, rating: value)
    }
}


// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
