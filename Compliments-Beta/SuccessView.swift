//
//  SuccessView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 7/4/20.
//

import SwiftUI

struct SuccessView: View {
    
    @Binding var isComplete: Bool
    
    var body: some View {
        Group {
            Text("Thank you for your feedback!")
                .font(.title3)
                .bold()
                .foregroundColor(.appTintColor)
                .padding(.top, isComplete ? 80 : 0)
        }
        .opacity(isComplete ? 1 : 0)
        .scaleEffect(isComplete ? 1 : 0)
    }
    
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView(isComplete: .constant(true))
    }
}
