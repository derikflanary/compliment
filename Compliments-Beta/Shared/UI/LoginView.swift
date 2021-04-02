//
//  LoginView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 4/1/21.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authenticationService: AuthenticationService
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var canLogIn: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
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
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 12)
            
            TextField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Spacer()
            
            Button(action: login, label: {
                Text("Log in")
                    .font(.headline)
                    .bold()
            })
            .buttonStyle(ActionButtonStyle())
            .padding(.vertical, 32)
            .disabled(!canLogIn)
            .opacity(canLogIn ? 1 : 0.2)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
    }

    func login() {
        withAnimation {
            authenticationService.isLoggedIn = true            
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
