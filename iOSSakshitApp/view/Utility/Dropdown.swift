//
//  DropDown.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 01/04/21.
//

import SwiftUI
import DropDown

struct Dropdown: UIViewRepresentable {
    
    var title: String
    var options: [String]
    @State var text: String = ""
    let dropDown = DropDown()
    
    var filtered: [String] {
        var list = options.filter { option in
            option.range(of: text, options: .caseInsensitive) != nil
        }
        list.append(text)
        return list
    }
    
    func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.placeholder = title
        view.borderStyle = .roundedRect
        
        dropDown.anchorView = view
        dropDown.direction = .bottom
        return view
    }
    
    func updateUIView(_ view: UITextField, context: Context) {
        view.text = text
        view.addAction(UIAction(title: "", handler: { action in
            let textField = action.sender as! UITextField
            text = textField.text ?? ""
            
            dropDown.dataSource = filtered
            dropDown.show()
        }), for: .editingChanged)
    }
}

struct DropDown_Previews: PreviewProvider {
    static var previews: some View {
        HStack(alignment: .top) {
            Dropdown(title: "Field", options: [])
        }
    }
}
