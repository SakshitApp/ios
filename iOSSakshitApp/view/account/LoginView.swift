//
//  LoginView.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 22/03/21.
//

import SwiftUI
import shared

struct LoginView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        VStack {
            if (viewModel.loading) {
                LinearProgressView()
                    .frame(height: 5, alignment: .center)
            } else {
                Spacer().frame(height: 5, alignment: .center)
            }
            VStack {
                Spacer()
                Image("Splash")
                Spacer()
                TextFieldView(title: "Email", text: $viewModel.email)
                SecureTextFieldView("Password", text: $viewModel.password)
                HStack {
                    Spacer()
                    ButtonView(text: "Forgot Password", type: .borderLess, action: {
                        viewModel.forgotPassword()
                    }).frame(width: 172)
                }
                ButtonView(text: "Login", type: .filled(25), action: {
                    viewModel.login()
                }).frame(minWidth: 0, maxWidth: .infinity)
                Text("--- Or ---")
                NavigationLink(destination: SignUpView(viewModel: SignUpView.ViewModel(repository: FCMUserRepository()))) {
                    Text("Create New User")
                        .font(.system(size: 18))
                        .padding()
                }
                Spacer()
            }.padding(EdgeInsets(top: 0, leading: 72, bottom: 0, trailing: 72))
            NavigationLink(destination: HomeView(), isActive: $viewModel.pushToHome) {
                EmptyView()
            }.hidden()
        }
        .popup(isPresented: viewModel.pushToRole, alignment: .center, content: {
            RoleView.init(viewModel: RoleView.ViewModel(repository: FCMUserRepository()))
        })
        .snackBar(text: $viewModel.error)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginView.ViewModel(repository: FCMUserRepository()))
    }
}

extension LoginView {
    enum LoadableLaunches {
        case loading
        case result(User)
        case error(String)
    }
    
    class ViewModel: ObservableObject {
        let repository: FCMUserRepository
        @Published var loading = false
        @Published var error:String? = nil
        @Published var pushToHome = false
        @Published var pushToRole = false
        @Published var email: String = ""
        @Published var password: String = ""
        
        init(repository: FCMUserRepository) {
            self.repository = repository
        }
        
        func forgotPassword() {
            self.loading = true
            repository.forgotPassword(email: self.email, completionHandler: {
                (isSuccess, error) in
                self.loading = false
                if error != nil {
                    self.error = error?.localizedDescription
                } else {
                    self.error = "Reset mail is sent to your email"
                }
            })
        }
        
        func login() {
            self.loading = true
            repository.login(email: self.email, password: self.password, completionHandler: {
                (user, error) in
                self.loading = false
                if let user = user {
                    if (user.role != nil) {
                        self.pushToHome = true
                    } else {
                        self.pushToRole = true
                    }
                } else {
                    self.error = error?.localizedDescription ?? "Error"
                }
            })
        }
    }
}
