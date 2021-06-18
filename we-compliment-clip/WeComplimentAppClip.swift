//
//  we_compliment_clipApp.swift
//  we-compliment-clip
//
//  Created by Derik Flanary on 10/4/20.
//

import SwiftUI
import AppClip

@main
struct ClipApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var authenticationService = AuthenticationService()
    @StateObject var network = NetworkManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.appLight, .appDark]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
    
                ClipContentView(networkManager: network)
                    .environmentObject(authenticationService)
            }
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
                respondTo(activity)
            }
        }
    }
    
    func respondTo(_ activity: NSUserActivity) {
        guard let incomingURL = activity.webpageURL,
              let components = URLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
              components.host == "www.we-compliment.com" else { return }
        
        if components.path.contains("test") {
            network.loadTest()
            return
        }
        
        guard let queryItems = components.queryItems,
              let clientId = queryItems.first?.value,
              let employeeId = queryItems.last?.value else { return }
        
        network.getClientDetails(clientId: clientId, employeeId: employeeId, activity: activity)
    }
    
}
