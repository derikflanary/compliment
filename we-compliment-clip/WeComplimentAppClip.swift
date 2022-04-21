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
    @StateObject var complimentService = ComplimentService()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.appLight, .appDark]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
    
                ClipContentView(complimentService: complimentService)
                    .environmentObject(authenticationService)
            }
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
                respondTo(activity)
            }
        }
    }
    
    func respondTo(_ activity: NSUserActivity) {
        complimentService.reset()
        
        let message = "The tag you scanned is invalid"
        guard let incomingURL = activity.webpageURL,
              let components = URLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
              components.host == "we-compliment.com" else {
            complimentService.errorMessage = message
            return
        }

        guard let queryItems = components.queryItems,
              let clientId = queryItems.first?.value,
              let employeeId = queryItems.last?.value else {
            complimentService.errorMessage = message
            return
        }
        
        if components.path.contains("test") {
            complimentService.loadTest(clientId: clientId, employeeId: employeeId)
            return
        }
        
        Task {
            await complimentService.getClientDetails(clientId: clientId, employeeId: employeeId, activity: activity)
        }
    }
    
}
