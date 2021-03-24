//
//  SplashView.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 22/03/21.
//

import SwiftUI
import shared

struct SplashView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .center){
            NavigationLink(destination: HomeView(), tag: "\(LoadableLaunches.result)", selection: $viewModel.launches) {
                EmptyView()
            }.hidden()
            NavigationLink(destination: LoginView(viewModel: LoginView.ViewModel(repository: FCMUserRepository())), tag: "\(LoadableLaunches.error)", selection: $viewModel.launches) {
                EmptyView()
            }.hidden()
            Image("Splash")
        }
        .popup(isPresented: viewModel.showRoleChange, alignment: .center, content: {
            RoleView.init(viewModel: RoleView.ViewModel(repository: FCMUserRepository()))
        })
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(viewModel: SplashView.ViewModel(repository: FCMUserRepository()))
    }
}

extension SplashView {
    enum LoadableLaunches: String {
        case loading
        case result
        case error
    }
    
    class ViewModel: ObservableObject {
        let repository: FCMUserRepository
        @Published var launches:String? = "\(LoadableLaunches.loading)"
        @State var showRoleChange = false
        
        init(repository: FCMUserRepository) {
            self.repository = repository
            self.load()
        }
        
        func load() {
            repository.getUser(forceReload: false) { (user, error) in
                if let user = user {
                    if user.role != nil {
                        self.launches = "\(LoadableLaunches.result)"
                    } else {
                        self.showRoleChange = true
                    }
                } else {
                    self.launches = "\(LoadableLaunches.error)"
                }
            }
        }
    }
}
