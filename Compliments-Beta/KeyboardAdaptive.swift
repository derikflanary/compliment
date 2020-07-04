//
//  KeyboardAdaptive.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 7/3/20.
//

import SwiftUI
import Combine
import UIKit

/// Adds bottom padding to adjust a view for the keyboard
/// - Note: Checks the presentationMode on the environment to adapt it for the TabBar or not
/// - Important: This should only be used to adapt scroll views.
struct KeyboardAdaptive: ViewModifier {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var keyboardHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(NotificationCenter.keyboardHeightPublisher) { height in
                guard height != 0 else {
                    self.keyboardHeight = height
                    return
                }
                
                withAnimation(.easeOut(duration: 0.25)) {
                    self.keyboardHeight = height
                }
            }
    }
    
}

extension View {
    
    /// Modifies the view by adding bottom padding to adjust for the keyboard
    /// - Note: Checks the presentationMode on the environment to adapt it for the TabBar or not
    /// - Important: This should only be used to adapt scroll views.
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
    
}


extension NotificationCenter {
    
    /// A publisher that emits the current height of the keyboard on the screen.
    /// - Note: `keyboardDidHide` was added because there is a SwiftUI bug when the keyboard dismisses from scrolling down on a modal sometimes it does not call `keyboardWillHide`
    static var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge3(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap {
                    $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                }
                .map { $0.height },
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in
                    CGFloat(0)
                },
            NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)
                .map { _ in
                    CGFloat(0)
                }
        )
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
}
