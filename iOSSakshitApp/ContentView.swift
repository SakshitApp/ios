//
//  ContentView.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 19/03/21.
//

import SwiftUI
import shared

struct ContentView: View {
    var body: some View {
        Text(Greeting().greeting())
                .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
