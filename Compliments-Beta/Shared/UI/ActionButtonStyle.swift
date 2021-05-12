//
//  ActionViewStyle.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 9/22/20.
//

import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    
    var backgroundColor: Color
    var foregroundColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(foregroundColor)
            .padding(.horizontal, 92)
            .padding(.vertical, 16)
            .background(backgroundColor)
            .cornerRadius(28)
            .shadow(color: configuration.isPressed ? .clear : Color.black.opacity(0.2), radius: 2, x: 0, y: 3)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
    }

}
