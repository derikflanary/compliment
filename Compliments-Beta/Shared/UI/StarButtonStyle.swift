//
//  StarButtonStyle.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 9/22/20.
//

import SwiftUI

struct StarButtonStyle: ButtonStyle {
    
    let color: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.9: 1)
    }
    
}
