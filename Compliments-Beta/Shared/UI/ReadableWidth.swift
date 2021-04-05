//
//  ReadableWidth.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 4/2/21.
//

import SwiftUI

/// Modifier that creates a readable width margin on both leading and trailing edges of views in the horizontal size class. Current readable width margin is 1/10 of the width of the screen
struct ReadableWidth: ViewModifier {
    
    // MARK: - Variables
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.presentationMode) var presentationMode
    @State private var regularSizeClassReadableWidthMargin: CGFloat = UIScreen.main.bounds.width / 10 // Margin to be added for regular size classes
    

    // MARK: - Body
    
    func body(content: Content) -> some View {
        return content
            .padding([.leading, .trailing], horizontalSizeClass == .regular ? regularSizeClassReadableWidthMargin : 0)
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                regularSizeClassReadableWidthMargin = UIScreen.main.bounds.height / 10 // Uses height because it goes off the previous orientation event though the notification says `didChange`
        }
    }
    
}


// MARK: - View extension

extension View {
    
    /// For adding the padding for regular size classes to conform more closely to a readable width
    func readableWidth() -> some View {
        return modifier(ReadableWidth())
    }
    
}
