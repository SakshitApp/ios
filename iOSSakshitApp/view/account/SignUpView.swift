//
//  SignUpView.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 23/03/21.
//

import SwiftUI
import shared

struct SignUpView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
                VStack {
                    TextFieldView(title: "Email", text: $viewModel.email)
                    SecureTextFieldView("Password", text: $viewModel.password)
                    Text("I will be")
                        .padding(EdgeInsets(top: 10, leading: 0,bottom: 0,trailing: 0))
                    Picker("I will be", selection: $viewModel.role) {
                        ForEach(UserRole.allCases) { season in
                            Text(season.rawValue).tag(season)
                        }
                    }.padding(EdgeInsets(top: 0, leading: 0,bottom: 10,trailing: 0))
                    .pickerStyle(SegmentedPickerStyle())
                    ButtonView(text: "Sign Up", type: .filled(25), action: {
                        viewModel.signUp()
                    }).frame(minWidth: 0, maxWidth: .infinity)
                    Text("--- Or ---")
                    ButtonView(text: "already signed up", type: .borderLess) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                Spacer()
            }.padding(EdgeInsets(top: 0, leading: 72, bottom: 0, trailing: 72))
            NavigationLink(destination: HomeTabView(), isActive: $viewModel.pushToHome) {
                EmptyView()
            }.hidden()
        }
        .snackBar(text: $viewModel.error)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: SignUpView.ViewModel(repository: FCMUserRepository()))
    }
}

extension SignUpView {
    enum LoadableLaunches {
        case loading
        case result(User)
        case error(String)
    }
    enum UserRole: String, CaseIterable, Identifiable {
        case student = "Studing"
        case teacher = "Teaching"
        
        var id: String { self.rawValue }
    }
    
    class ViewModel: ObservableObject {
        let repository: FCMUserRepository
        @Published var loading = false
        @Published var error:String? = nil
        @Published var pushToHome = false
        @Published var email: String = ""
        @Published var password: String = ""
        @Published var role: String = UserRole.student.id
        
        init(repository: FCMUserRepository) {
            self.repository = repository
        }
        
        func signUp() {
            self.loading = true
            let role = (self.role != UserRole.student.id) ? Role.userExpert:Role.userStudent
            repository.signUp(email: self.email, password: self.password, role: role, completionHandler: {
                (user, error) in
                self.loading = false
                if user != nil {
                    self.pushToHome = true
                } else {
                    self.error = error?.localizedDescription ?? "Error"
                }
            })
        }
    }
}
