//
//  TextFieldView.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 22/03/21.
//

import SwiftUI

struct TextFieldView: View {
    
    var title: String
    @Binding var text: String
    
    var body: some View {
        TextField(title, text: $text)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color("AccentColor"), lineWidth: 2))
    }
}

struct TextFieldView_Previews: PreviewProvider {
    
    static var previews: some View {
        TextFieldView(title: "Email", text: .constant(""))
    }
}
