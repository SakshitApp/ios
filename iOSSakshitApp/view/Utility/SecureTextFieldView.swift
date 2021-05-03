//
//  SecureTextFieldView.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 22/03/21.
//

import SwiftUI

struct SecureTextFieldView: View {
    
    var title: String
    @Binding var text: String
    @State private var isSecured: Bool = true
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        HStack {
            if isSecured {
                SecureField(title, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            } else {
                TextField(title, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    
            }
            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: self.isSecured ? "eye" : "eye.slash")
                    .accentColor(Color("AccentColor"))
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color("AccentColor"), lineWidth: 2))
    }
}

struct SecureTextFieldView_Previews: PreviewProvider {
    
    static var previews: some View {
        SecureTextFieldView("Password", text: .constant(""))
    }
}
