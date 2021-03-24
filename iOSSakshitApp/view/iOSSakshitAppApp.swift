//
//  iOSSakshitAppApp.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 19/03/21.
//

import SwiftUI
import Firebase
import shared

@main
struct iOSSakshitAppApp: App {
    
    init() {
        FirebaseApp.configure()
        SharedFactory.Companion.init().initialize()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
