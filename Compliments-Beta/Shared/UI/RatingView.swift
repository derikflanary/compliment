//
//  RatingView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 5/12/21.
//

import SwiftUI

struct RatingView: View {

    // MARK: - Binding
    
    @Binding var rating: Int
    
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            HStack {
                Text("Select an rating for this employee based on the service you received")
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .padding(.bottom, 8)
            .padding(.leading, 2)
        }
    }
    
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView()
    }
}
