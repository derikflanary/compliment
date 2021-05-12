//
//  ContentView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 7/3/20.
//

import SwiftUI
import StoreKit

struct ClipContentView: View {
    
    
    // MARK: - State Objects
    
    @StateObject var network = NetworkManager()
    
    
    // MARK: - State
    
    @State private var message: String = ""
    @State private var showDownloadPrompt = false
    @State private var selectedAnswer: Answer?
    @State private var isEditingText: Bool = false
    @State private var textViewContentHeight: CGFloat = 38
    
    
    // MARK: - Properties
    
    private let potentialAnswers = [Answer(title: "Bronze", color: .orange, value: 1), Answer(title: "Silver", color: .gray, value: 2), Answer(title: "Gold", color: .yellow, value: 3)]
    private let textViewId = "textViewId"
    private let minTextViewHeight: CGFloat = 112
    private var maxCharacterCount: Int = 250
    private var hasSurpassedMaxCount: Bool {
        message.count > maxCharacterCount
    }
    private var buttonIsEnabled: Bool {
        selectedAnswer != nil && !message.isBlank && !hasSurpassedMaxCount
    }
    
    
    // MARK: - Body
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(showsIndicators: false) {
                VStack {
                    Text("compliment")
                        .tracking(2)
                        .font(.system(size: 36, weight: .light, design: .default))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.white, lineWidth: 1)
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
                            Text("Tell us why?")
                                .font(.title3)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 8)
                        .padding(.leading, 2)
                        
                        TextView(text: $message, isEditing: $isEditingText, placeholder: "Leave feedback here...", textColor: .label) { contentSize in
                            DispatchQueue.main.async {
                                withAnimation {
                                    textViewContentHeight = contentSize.height
                                }
                            }
                        }
                        .frame(height: max(minTextViewHeight, textViewContentHeight))
                        .onTapGesture {
                            delayOnMainThread(0.5) {
                                withAnimation {
                                    scrollProxy.scrollTo(textViewId, anchor: .bottom)
                                }
                            }
                        }
                        .id(textViewId)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(4)
                        
                        HStack {
                            Spacer()
                            
                            Text("\(message.count) / \(maxCharacterCount)")
                                .font(.footnote)
                                .foregroundColor(hasSurpassedMaxCount ? .red : .white)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            sendCompliment()
                        }, label: {
                            if network.isSending {
                                ProgressView()
                            } else {
                                Text("Submit")
                                    .font(.headline)
                                    .bold()
                            }
                        })
                        .buttonStyle(ActionButtonStyle(backgroundColor: .appGreen, foregroundColor: .white))
                        .padding(.vertical, 32)
                        .disabled(!buttonIsEnabled || network.isSending)
                        .opacity(buttonIsEnabled ? 1.0 : 0.2)
                    }
                    .opacity(network.isComplete ? 0.0 : 1)
                }
                .padding(.horizontal, 20)
                .padding(.vertical)
            }
            .onTapGesture {
                UIWindow.currentWindow?.endEditing(true)
            }
            .readableWidth()
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
            ClipContentView()
        }
    }
}
