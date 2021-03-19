//
//  iOSSakshitAppApp.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 19/03/21.
//

import SwiftUI
import Firebase

@main
struct iOSSakshitAppApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
