//
//  CircleButtonView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 7/3/20.
//

import SwiftUI

struct CircleButton: View {
    
    var isSelected: Bool
    let title: String
    var tapped: (() -> Void) = { }
    
    var body: some View {
        VStack {
            Button(action: {
                tapped()
            }, label: {
                Circle()
            })
            .buttonStyle(CircleButtonStyle(isSelected: isSelected))
            
            Text("\(title)")
                .font(.subheadline)
                .foregroundColor(Color(.secondaryLabel))
        }
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleButton(isSelected: true, title: "This Employee was")
    }
}
