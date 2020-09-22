//
//  ActionViewStyle.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 9/22/20.
//

import SwiftUI

struct ActionButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .foregroundColor(Color(.label))
            .padding(.horizontal, 92)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
            .cornerRadius(28)
            .shadow(color: configuration.isPressed ? .clear : Color.black.opacity(0.2), radius: 2, x: 0, y: 3)
            .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color(.label), lineWidth: 2)
            )
    }

}
