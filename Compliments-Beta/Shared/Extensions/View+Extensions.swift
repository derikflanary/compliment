//
//  View+Extensions.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 10/7/20.
//

import SwiftUI

extension View {
    
    func delayOnMainThread(_ duration: Double, _ completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: completion)
    }
    
}
