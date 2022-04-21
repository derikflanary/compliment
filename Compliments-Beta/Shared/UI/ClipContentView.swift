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
    
    @ObservedObject var complimentService: ComplimentService
   
    
    // MARK: - State
    
    @State private var isDebug: Bool = false
    
    
    // MARK: - Init
    
    init(complimentService: ComplimentService) {
        self.complimentService = complimentService
    }
    
    
    // MARK: - Body
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(showsIndicators: false) {
                VStack {
                    Text("compliment")
                        .tracking(2)
                        .font(.system(size: 36, weight: .light, design: .default))
                        .padding(.horizontal, .small)
                        .padding(.vertical, .minimal)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .onTapGesture(count: 3, perform: {
                            complimentService.isComplete = false
                            isDebug.toggle()
                        })
                    
                    if complimentService.failedFromInvalidLocation {
                        Text("We were not able to verify that you are located near the designated location where you received your service.  You can only leave feedback near the the business's location")
                            .padding()
                            .multilineTextAlignment(.center)
                            .transition(.opacity)
                            .foregroundColor(.white)
                    } else if let errorMessage = complimentService.errorMessage {
                        Text(errorMessage)
                            .padding()
                            .multilineTextAlignment(.center)
                            .transition(.opacity)
                            .foregroundColor(.white)
                    }
                    
                    if complimentService.isComplete {
                        Spacer()
                        
                        SuccessView(isComplete: $complimentService.isComplete)
                            .transition(.scale)
                            .padding(.top, 60)
                            .onAppear {
                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                            }
                    }
                    
                    FeedbackView(complimentService: complimentService, scrollProxy: scrollProxy)
                        .opacity(complimentService.isComplete ? 0.0 : 1)
                    
                    if complimentService.isValidating {
                        ProgressView()
                            .padding()
                    }
                    
                    if isDebug {
                        Text(complimentService.response ?? "")
                            .padding()
                            .foregroundColor(.white)
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
            ClipContentView(complimentService: ComplimentService())
        }
    }
}
