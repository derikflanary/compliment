//
//  FeedbackView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 6/18/21.
//

import SwiftUI

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
