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
                            .transition(.opacity)
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
