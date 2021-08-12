//
//  LoginView.swift
//  PersonalityTest
//
//  Created by Dragos Iancu on 05/01/2021.
//

import SwiftUI
import Combine

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()
    
    var placeHolderTextView: some View {
        PlaceholderTextField(placeholder: Text("Username"), text: $viewModel.username)
            .padding(.top, 32.0)
    }
    
    var passwordTextView: some View {
        SecurePlaceholderTextField(placeholder: Text("Password"), text: $viewModel.password)
            .padding(.top, 32.0)
    }
    
    var titleView: some View {
        HStack(alignment: .center){
            Spacer()
            VStack(alignment: .center) {
                Text("Welcome to")
                    .tracking(1.0)
                Text("Personality Test App").fontWeight(.bold)
            }
            Spacer()
        }.padding(EdgeInsets(top: 44.0, leading: .zero, bottom: .zero, trailing: .zero))
    }
    
    var body: some View {
        NavigationView {
            LoadingView(isShowing: .constant(viewModel.isLoading)) {
                VStack(alignment: .leading) {
                    Spacer()
                    self.titleView
                    Spacer()
                    self.placeHolderTextView
                    self.passwordTextView
                    Spacer()
                    HStack(alignment: .center){
                        Spacer()
                        Button(action: {
                            self.loginUser()
                        }) {
                            Text("Login Now 👌")
                                .foregroundColor(Color.white)
                        }.frame(minWidth: 150.0, minHeight: 50.0, maxHeight: 50.0)
                        .background(Color.blue)
                        .cornerRadius(2.5)
                        .padding(.top, 20.0)
                        Spacer()
                    }
                    Spacer()
                }.padding(22.0)
            }
            .navigationBarHidden(true)
        }
        
    }
    
    private func loginUser() {
        viewModel.login()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
