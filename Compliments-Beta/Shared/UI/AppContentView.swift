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
                DashboardView()
                    .environmentObject(authenticationService)
            } else {
                LoginView()
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
    
    @Published var isLoggedIn: Bool = false
    
}
