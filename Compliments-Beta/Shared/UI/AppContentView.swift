//
//  AppContentView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 4/1/21.
//

import SwiftUI

struct AppContentView: View {
    
    @StateObject var authenticationService = AuthenticationService()
    
    
    var body: some View {
        ZStack {
            if authenticationService.isLoggedIn {
                ClipContentView(networkManager: NetworkManager())
                    .environmentObject(authenticationService)
            } else {
                EnterCodeView()
                    .environmentObject(authenticationService)
            }
        }
        .readableWidth()
    }
    
}

struct AppContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppContentView()
    }
}

class AuthenticationService: ObservableObject {
    
    @Published var userId: String? = nil
    @Published var isLoggedIn: Bool = false
    
}
