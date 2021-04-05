//
//  DashboardView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 4/1/21.
//

import SwiftUI

struct DashboardView: View {
    
    @EnvironmentObject var authenticationService: AuthenticationService
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Service Inc.")
                    .font(.title)
                    .padding(.bottom, 4)
                
                Text("Total Awards Received: 184")
                    .padding(.bottom)
                
                VStack(alignment: .leading ,spacing: 2) {
                    Text("Gold: 84")
                        
                    HStack {
                        ProgressView(value: 84, total: 84)
                            .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                            .scaleEffect(x: 1, y: 4, anchor: .center)
                        
                        Image(systemName: "star")
                            .foregroundColor(.orange)
                    }
                }
                .padding(.bottom)
                
                VStack(alignment: .leading ,spacing: 2) {
                    Text("Silver: 50")
                        
                    HStack {
                        ProgressView(value: 50, total: 84)
                            .progressViewStyle(LinearProgressViewStyle(tint: .gray))
                            .scaleEffect(x: 1, y: 4, anchor: .center)
                        
                        Image(systemName: "star")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom)
                
                VStack(alignment: .leading ,spacing: 2) {
                    Text("Bronze: 50")
                        
                    HStack {
                        ProgressView(value: 50, total: 84)
                            .progressViewStyle(LinearProgressViewStyle(tint: .yellow))
                            .scaleEffect(x: 1, y: 4, anchor: .center)
                        
                        Image(systemName: "star")
                            .foregroundColor(.yellow)
                    }
                }
                
                Spacer()
                
            }
            .padding(20)
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                                    Menu(content: {
                                        Button(action: logOut) {
                                            Text("Log Out")
                                        }
                                    }, label: {
                                        Image(systemName: "gearshape")
                                    })
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func logOut() {
        authenticationService.isLoggedIn = false
    }
    
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
