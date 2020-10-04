//
//  we_compliment_clipApp.swift
//  we-compliment-clip
//
//  Created by Derik Flanary on 10/4/20.
//

import SwiftUI

@main
struct we_compliment_clipApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
                    respondTo(activity)
                }
        }
    }
    
    func respondTo(_ activity: NSUserActivity) {
        guard let incomingURL = activity.webpageURL else { return }
        guard let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else { return }
        print(components)
        // Update the user interface based on URL components passed to the app clip.
    }
    
}
