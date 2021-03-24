//
//  RoleView.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 24/03/21.
//

import SwiftUI
import shared

struct RoleView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            VStack {
                if (viewModel.loading) {
                    LinearProgressView()
                        .frame(height: 5, alignment: .center)
                } else {
                    Spacer().frame(height: 5, alignment: .center)
                }
                Text("I will be")
                    .padding(EdgeInsets(top: 10, leading: 0,bottom: 0,trailing: 0))
                Picker("I will be", selection: $viewModel.role) {
                    ForEach(UserRole.allCases) { season in
                        Text(season.rawValue).tag(season)
                    }
                }.padding(EdgeInsets(top: 0, leading: 0,bottom: 10,trailing: 0))
                .pickerStyle(SegmentedPickerStyle())
                ButtonView(text: "Save", type: .filled(25), action: {
                    viewModel.signUp()
                }).frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            }
            .padding()
            .background(Color.white)
            NavigationLink(destination: HomeView(), isActive: $viewModel.pushToHome) {
                EmptyView()
            }.hidden()
        }
        .frame(minHeight: 0, maxHeight: .infinity, alignment: .bottom)
        .background(Color.gray.opacity(0.5))
        .snackBar(text: $viewModel.error)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct RoleView_Previews: PreviewProvider {
    static var previews: some View {
        RoleView(viewModel: RoleView.ViewModel(repository: FCMUserRepository()))
    }
}

extension RoleView {
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
        @Published var role: String = UserRole.student.id
        
        init(repository: FCMUserRepository) {
            self.repository = repository
        }
        
        func signUp() {
            self.loading = true
            let role = (self.role != UserRole.student.id) ? Role.userExpert:Role.userStudent
            repository.setRole(role: role, completionHandler: {
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
