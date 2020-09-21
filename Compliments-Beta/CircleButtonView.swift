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
        Group {
            CircleButton(isSelected: true, title: "This Employee was")
        }
    }
}


struct StarButton: View {
    
    var isSelected: Bool
    let title: String
    let color: Color
    var tapped: (() -> Void) = { }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Button(action: {
                tapped()
            }, label: {
                Image(systemName: isSelected ? "star.fill" : "star")
                    .font(.largeTitle)
                    .foregroundColor(color)
                    .animation(.spring())
                    .transition(.scale)
            })
            
            Text("\(title)")
                .font(.subheadline)
                .foregroundColor(Color(.secondaryLabel))
        }
    }
}

struct StarButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StarButton(isSelected: true, title: "This Employee was", color: .orange)
        }
    }
}
