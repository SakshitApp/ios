//
//  HomeView.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 22/03/21.
//

import SwiftUI
import shared

struct HomeTabView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        TabView {
            ExpertHomeView(viewModel: ExpertHomeView.ViewModel(repository: CourseRepository()))
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            Text("View")
                .tabItem {
                    Image(systemName: "tv.fill")
                    Text("Second Tab")
                }
        }.navigationBarTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
