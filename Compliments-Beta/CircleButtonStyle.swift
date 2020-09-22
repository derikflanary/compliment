//
//  CircleButtonStyle.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 7/3/20.
//

import SwiftUI

struct CircleButtonStyle: ButtonStyle {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var isSelected: Bool
    @ScaledMetric var height: CGFloat = 40
    @ScaledMetric var innerHeight: CGFloat = 30

    private var buttonHeight: CGFloat {
        .regular == horizontalSizeClass ? height * 2 : height
    }
    private var innerButtonHeight: CGFloat {
        .regular == horizontalSizeClass ? innerHeight * 2 : innerHeight
    }

    
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
                        .animation(Animation.spring(dampingFraction: 0.5).speed(2.0)))
    }
    
}


struct StarButtonStyle: ButtonStyle {
    
    let color: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.9: 1)
    }
    
}

extension AnyTransition {

    static func scaleInFadeOut() -> AnyTransition {
        let insertion = AnyTransition.scale
        let removal = AnyTransition.opacity
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
}

