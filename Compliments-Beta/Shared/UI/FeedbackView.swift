//
//  FeedbackView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 6/18/21.
//

import SwiftUI

struct FeedbackView: View {
    
    // MARK: - Observed Objects
    
    @ObservedObject var complimentService: ComplimentService
   
    
    // MARK: - Init
    
    init(complimentService: ComplimentService, scrollProxy: ScrollViewProxy) {
        self.complimentService = complimentService
        self.scrollProxy = scrollProxy
    }

    
    // MARK: - State
    
    @State private var message: String = ""
    @State private var rating: Double = 0
    @State private var isEditingText: Bool = false
    @State private var textViewContentHeight: CGFloat = 48

    
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
        if complimentService.clientType == .one {
            return rating > 0 && !message.isBlank && !hasSurpassedMaxCount
        } else {
            return !message.isBlank && !hasSurpassedMaxCount
        }
    }
    
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            switch complimentService.clientType {
            case .one:
                RatingView($rating, maxRating: maxRating)
            case .two:
                EmptyView()
            case .three:
                EmptyView()
            }
            HStack {
                Text(complimentService.clientType.explanationText)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.top, 20)
            .padding(.bottom, 8)
            .padding(.leading, 2)
            
            TextView(text: $message, isEditing: $isEditingText, placeholder: Localized.responsePlaceholder, textColor: .label) { contentSize in
                DispatchQueue.main.async {
                    withAnimation {
                        textViewContentHeight = contentSize.height
                    }
                }
            }
            .frame(height: max(minTextViewHeight, textViewContentHeight))
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
                if complimentService.isSending {
                    ProgressView()
                } else {
                    Text(Localized.submit)
                        .font(.headline)
                        .bold()
                }
            })
            .buttonStyle(ActionButtonStyle(backgroundColor: .appGreen, foregroundColor: .white))
            .padding(.vertical, .doubleLarge)
            .disabled(!buttonIsEnabled || complimentService.isSending)
            .opacity(buttonIsEnabled ? 1.0 : 0.2)
            
            Text(Localized.disclaimer)
                .font(.footnote)
                .foregroundColor(.disclaimer)
                .padding(.top, .negativeLarge)
        }
        .padding(.top, 40)
    }
    
}


// MARK: - Private

private extension FeedbackView {
    
    func sendCompliment() {
        UIWindow.currentWindow?.endEditing(true)
        Task {
            await complimentService.sendCompliment(comment: message, rating: rating)
        }
    }
    
}
