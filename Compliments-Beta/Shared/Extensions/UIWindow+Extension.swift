//
//  UIWindow+Extension.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 7/3/20.
//

import UIKit

extension UIWindow {
    
    static var currentWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }.first
    }
    
}
