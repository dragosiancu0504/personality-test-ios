//
//  HomeView.swift
//  PersonalityTest
//
//  Created by Dragos Iancu on 05/01/2021.
//

import SwiftUI

struct HomeView: View {
    var seeDoggoButton: some View {
        NavigationLink(destination: FullImageView(url: ApiRoutes.testDogUrl)) {
            Text("Dog Pic?").foregroundColor(Color.white)
        }.frame(minWidth: 150.0, minHeight: 50.0, maxHeight: 50.0)
        .background(Color.blue)
        .cornerRadius(2.5)
        .padding(.top, 20.0)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Second Tab")
                
                seeDoggoButton
                
                Spacer()
                
                Button(action: {
                    AuthHandler.shared.logout()
                }) {
                    Text("Logout")
                }
                Spacer()
            }
        }.navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
