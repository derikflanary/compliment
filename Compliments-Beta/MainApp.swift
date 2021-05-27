//
//  Compliments_BetaApp.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 7/3/20.
//

import SwiftUI

@main
struct MainApp: App {
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.appLight, .appDark]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                AppContentView()
            }
        }
    }
    
}
