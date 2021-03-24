//
//  ButtonView.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 22/03/21.
//

import SwiftUI

struct ButtonView: View {
    
    var text: String
    var type: ButtonType
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            switch(type) {
            case .borderLess: Text(text)
                .font(.system(size: 18))
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
            case .outlined(let size): Text(text)
                .font(.system(size: 18))
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(Color("AccentColor"))
                .overlay(
                    RoundedRectangle(cornerRadius: size)
                        .stroke(Color("AccentColor"), lineWidth: 2))
            case .filled(let size): Text(text)
                .font(.system(size: 18))
                .foregroundColor(Color("InvertColor"))
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: size).foregroundColor(Color("AccentColor")))
                
            }
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "Click", type: .filled(25), action: {})
    }
}

extension ButtonView {
    enum ButtonType {
        case borderLess
        case outlined(CGFloat)
        case filled(CGFloat)
    }
}
