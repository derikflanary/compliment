//
//  StarButton.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 9/22/20.
//

import SwiftUI

struct StarButton: View {
    
    // MARK: - Properties
    
    var isSelected: Bool
    let title: String
    let color: Color
    var tapped: (() -> Void) = { }
    
    
    // MARK: - Bodey
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Button(action: {
                tapped()
            }, label: {
                if isSelected {
                    Image(systemName: "star.fill")
                        .foregroundColor(color)
                        .font(.system(size: 48, weight: .regular, design: .default))
                        .transition(.scaleInFadeOut())
                } else {
                    Image(systemName: "star")
                        .foregroundColor(.white)
                        .opacity(0.2)
                        .font(.system(size: 48, weight: .regular, design: .default))

                }
            })
            .buttonStyle(StarButtonStyle(color: color))
        }
    }
}


// MARK: - Previews

struct StarButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StarButton(isSelected: true, title: "Bronze", color: .orange)
            StarButton(isSelected: false, title: "Bronze", color: .orange)
        }
    }
}
