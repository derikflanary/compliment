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
        VStack(spacing: 16) {
            Spacer()
            
            Text("Success!")
                .foregroundColor(.appTintColor)
                .font(.title)
                .bold()
            Text("Your response has been submitted")
            
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
                .foregroundColor(.appTintColor)
            
            Spacer()
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
