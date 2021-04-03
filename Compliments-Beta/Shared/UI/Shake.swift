//
//  Shake.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 4/2/21.
//

import SwiftUI

/// Add a shake animation to a View
///
/// - Note: To be used as so: `.modifier(Shake(animatableData: float)).animation(.easeInOut)`
///
/// - Parameters:
///   - offset: The amount to offset the shake to the left and right of the view
///   - shakesPerUnit: The amount of shakes to perform
///   - animitableData: To perform an animation you just need to increment this variable by 1
///
struct Shake: GeometryEffect {
    
    var offset: CGFloat = 4
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: offset * sin(animatableData * .pi * CGFloat(shakesPerUnit)), y: 0))
    }
    
}
