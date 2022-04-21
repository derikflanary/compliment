//
//  CircleButtonStyle.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 7/3/20.
//

import SwiftUI

struct CircleButtonStyle: ButtonStyle {
    
    // MARK: - Environment
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    

    // MARK: - Scaled metrics
    
    @ScaledMetric var height: CGFloat = 40
    @ScaledMetric var innerHeight: CGFloat = 30

    
    // MARK: - Properties
    
    var isSelected: Bool
    private var buttonHeight: CGFloat {
        .regular == horizontalSizeClass ? height * 2 : height
    }
    private var innerButtonHeight: CGFloat {
        .regular == horizontalSizeClass ? innerHeight * 2 : innerHeight
    }

    
    // MARK: - Body
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: buttonHeight, height: buttonHeight)
            .foregroundColor(Color(.systemGroupedBackground))
            .overlay(Circle().stroke(Color.appTintColor, lineWidth: 1))
            .scaleEffect(configuration.isPressed ? 1.05 : 1)
            .overlay(Circle()
                        .foregroundColor(.appTintColor)
                        .frame(width: innerButtonHeight, height: innerButtonHeight)
                        .scaleEffect(isSelected ? 1.0 : 0.0)
                        .animation(Animation.spring(dampingFraction: 0.5).speed(2.0), value: isSelected))
    }
    
}
