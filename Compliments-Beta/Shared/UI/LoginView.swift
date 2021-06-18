//
//  LoginView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 4/1/21.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @EnvironmentObject var authenticationService: AuthenticationService
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var failureCount: CGFloat = 0
    
    private let testUserName = "demoUser"
    private let testPassword = "demo"
    
    private var canLogIn: Bool {
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
                .disableAutocorrection(true)
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Spacer()
            
            Button(action: login, label: {
                Text("Log in")
                    .font(.headline)
                    .bold()
            })
            .buttonStyle(ActionButtonStyle(backgroundColor: .green, foregroundColor: .white))
            .padding(.top, 32)
            .disabled(!canLogIn)
            .opacity(canLogIn ? 1 : 0.2)
            .modifier(Shake(animatableData: failureCount))
            .animation(.spring())
            
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.email]
            } onCompletion: { result in
                switch result {
                case let .success(authorization):
                    guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
                    authenticationService.userId = credential.user
                case .failure(let error):
                    print(error)
                    failureCount += 1
                }
            }
            .frame(height: 48)
            .padding()

        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
    }

    func login() {
        if username == testUserName && password == testPassword {
            withAnimation {
                authenticationService.isLoggedIn = true
            }
        } else {
            failureCount += 1
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
