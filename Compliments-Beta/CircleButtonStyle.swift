//
//  CircleButtonStyle.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 7/3/20.
//

import SwiftUI

struct CircleButtonStyle: ButtonStyle {
    
    var isSelected: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 40, height: 40)
            .foregroundColor(Color(.systemGroupedBackground))
            .overlay(Circle().stroke(Color.appTintColor, lineWidth: 1))
            .scaleEffect(configuration.isPressed ? 1.05 : 1)
            .overlay(Circle()
                        .foregroundColor(.appTintColor)
                        .frame(width: 30, height: 30)
                        .scaleEffect(isSelected ? 1.0 : 0.0)
                        .animation(Animation.spring(dampingFraction: 0.5).speed(2.0))
                        .transition(.scale))
    }
    
}
