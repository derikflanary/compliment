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
                if isSelected {
                    Image(systemName: "star.fill")
                        .foregroundColor(color)
                        .font(.system(size: 48, weight: .bold, design: .default))
                        .transition(.scaleInFadeOut())
                } else {
                    Image(systemName: "star")
                        .foregroundColor(color)
                        .font(.system(size: 48, weight: .bold, design: .default))

                }
            })
            .buttonStyle(StarButtonStyle(color: color))
            
            Text("\(title)")
                .font(.subheadline)
                .foregroundColor(color)
        }
    }
}

struct StarButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StarButton(isSelected: true, title: "Bronze", color: .orange)
            StarButton(isSelected: false, title: "Bronze", color: .orange)
        }
    }
}
