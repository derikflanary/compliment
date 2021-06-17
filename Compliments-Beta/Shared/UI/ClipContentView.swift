//
//  ContentView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 7/3/20.
//

import SwiftUI
import StoreKit

struct ClipContentView: View {
    
    
    // MARK: - Observed Objects
    
    @ObservedObject var network: NetworkManager
   
    
    // MARK: - Init
    
    init(networkManager: NetworkManager) {
        self.network = networkManager
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
                    
                    if network.failedFromInvalidLocation {
                        Text("We were not able to verify that you are located near the designated location where you received your service.  You can only leave feedback near the the business's location")
                            .padding()
                            .multilineTextAlignment(.center)
                    }
                    
                    if network.isComplete {
                        Spacer()
                        
                        SuccessView(isComplete: $network.isComplete)
                            .transition(.scale)
                            .padding(.top, 60)
                            .onAppear {
                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                            }
                    }
                    
                    if network.isValidLocation {
                        FeedbackView(networkManager: network, scrollProxy: scrollProxy)
                            .opacity(network.isComplete ? 0.0 : 1)
                    }
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
    
}


// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ClipContentView(networkManager: NetworkManager())
        }
    }
}


struct FeedbackView: View {
    
    // MARK: - Observed Objects
    
    @ObservedObject var network: NetworkManager
   
    
    // MARK: - Init
    
    init(networkManager: NetworkManager, scrollProxy: ScrollViewProxy) {
        self.network = networkManager
        self.scrollProxy = scrollProxy
    }

    
    // MARK: - State
    
    @State private var message: String = ""
    @State private var rating: Double = 0
    @State private var isEditingText: Bool = false
    @State private var textViewContentHeight: CGFloat = 38

    
    // MARK: - Properties
    
    private let scrollProxy: ScrollViewProxy
    private let potentialAnswers = [Answer(title: "Bronze", color: .orange, value: 1), Answer(title: "Silver", color: .gray, value: 2), Answer(title: "Gold", color: .yellow, value: 3)]
    private let textViewId = "textViewId"
    private let maxRating: Int = 5
    private let minTextViewHeight: CGFloat = 160
    private var maxCharacterCount: Int = 500
    private var hasSurpassedMaxCount: Bool {
        message.count > maxCharacterCount
    }
    private var buttonIsEnabled: Bool {
        rating > 0 && !message.isBlank && !hasSurpassedMaxCount
    }
    private var ratingString: String {
        String(format: "%.1f stars", rating)
    }
    
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            Spacer()
            
            Text("Select a rating for this employee based on the service you received")
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(.top, 40)
        .padding(.bottom, 20)
        .padding(.leading, 2)
        
        RatingView($rating, maxRating: maxRating)
        
        Text(ratingString)
            .font(.title3)
            .foregroundColor(.white)
        
        HStack {
            Text("Briefly tell us why")
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.top, 20)
        .padding(.bottom, 8)
        .padding(.leading, 2)
        
        TextView(text: $message, isEditing: $isEditingText, placeholder: "Please leave your response here", textColor: .label) { contentSize in
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
    
}

// MARK: - Private

private extension FeedbackView {
    
    func sendCompliment() {
        UIWindow.currentWindow?.endEditing(true)
        network.sendCompliment(comment: message, rating: rating)
    }
    
}
