//
//  ComplimentsAppClipApp.swift
//  ComplimentsAppClip
//
//  Created by Derik Flanary on 7/3/20.
//

import SwiftUI
import UIKit

@main
struct ComplimentsAppClipApp: App {
    
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
