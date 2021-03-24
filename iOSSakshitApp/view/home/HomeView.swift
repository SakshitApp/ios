//
//  HomeView.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 22/03/21.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            Text("Welcome Home!")
            Button(
                "Here is Home View. Tap to go back.",
                action: { self.presentationMode.wrappedValue.dismiss() }
            )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
