//
//  SuccessView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 7/4/20.
//

import SwiftUI

struct SuccessView: View {
    
    @EnvironmentObject var authenticationService: AuthenticationService
    
    @Binding var isComplete: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Text("Success!")
                .foregroundColor(.appTintColor)
                .font(.title)
                .bold()
            Text("Your response has been submitted")
                .foregroundColor(.white)
            
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
                .foregroundColor(.appTintColor)
            
            Spacer()
            
            if authenticationService.isLoggedIn {
                Button(action: {
                    withAnimation {
                        authenticationService.isLoggedIn = false
                        isComplete = false
                    }
                }, label: {
                    Text("Enter another code")
                })
                .foregroundColor(.white)
                .buttonStyle(ActionButtonStyle(backgroundColor: .appGreen, foregroundColor: .white))
                .padding()
            }
        }
        .opacity(isComplete ? 1 : 0)
        .scaleEffect(isComplete ? 1 : 0)
    }
    
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView(isComplete: .constant(true))
    }
}
