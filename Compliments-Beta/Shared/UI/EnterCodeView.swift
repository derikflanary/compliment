//
//  EnterCodeView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 5/27/21.
//

import SwiftUI

struct EnterCodeView: View {
    
    @EnvironmentObject var authenticationService: AuthenticationService
    
    @State private var code: String = ""
    @State private var failureCount: CGFloat = 0
    
    private var canSubmitCode: Bool {
        !code.isBlank
    }
    private let testCode = "TESTCODE1"
    
    var body: some View {
        VStack {
            Text("compliment")
                .tracking(3)
                .font(.system(size: 36, weight: .light, design: .default))
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .foregroundColor(.appTintColor)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.appTintColor, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                )
            
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.appTintColor)
                .padding(40)
            
            TextField("Enter your code...", text: $code)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .textContentType(.oneTimeCode)
            
            Text("Enter the signle-use code above that you recently received from the company that provided you service. Let them know how the person who served you performed and what they could do to improve.")
                .font(.footnote)
                .foregroundColor(Color(.white))
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            Button(action: submit, label: {
                Text("Submit")
                    .font(.headline)
                    .bold()
            })
            .buttonStyle(ActionButtonStyle(backgroundColor: .green, foregroundColor: .white))
            .padding(.top, 32)
            .disabled(!canSubmitCode)
            .opacity(canSubmitCode ? 1 : 0.2)
            .modifier(Shake(animatableData: failureCount))
            .animation(.spring())
        }
        .padding()
    }
    
    func submit() {
        if code.trimmingCharacters(in: .whitespacesAndNewlines) == testCode {
            withAnimation {
                authenticationService.isLoggedIn = true                
            }
        } else {
            failureCount += 1
        }
    }
    
}


struct EnterCodeView_Previews: PreviewProvider {
    static var previews: some View {
        EnterCodeView()
    }
}
