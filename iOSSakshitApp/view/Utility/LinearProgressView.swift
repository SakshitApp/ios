//
//  LinearProgressView.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 22/03/21.
//

import SwiftUI
import MaterialComponents.MaterialProgressView

struct LinearProgressView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> MDCProgressView {
        MDCProgressView()
    }
    
    func updateUIView(_ view: MDCProgressView, context: Context) {
        view.mode = .indeterminate
        view.progressTintColor = UIColor(named: "AccentColor")
        view.trackTintColor = UIColor(named: "AccentColor")?.withAlphaComponent(0.3)
        view.startAnimating()
    }
    
}

struct LinearProgressView_Previews: PreviewProvider {
    static var previews: some View {
        LinearProgressView()
    }
}
