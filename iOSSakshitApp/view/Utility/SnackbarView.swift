//
//  SnackbarView.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 22/03/21.
//

import SwiftUI

struct SnackbarView: View {
    
    private let presenting: AnyView
    @Binding private var text: String?
    @Binding private var actionText: String?
    private let action: (() -> Void)?
    
    private var isBeingDismissedByAction: Bool {
        actionText != nil && action != nil
    }
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    init<Presenting>(presenting: Presenting,
                     text: Binding<String?>,
                     actionText: Binding<String?>,
                     action: (() -> Void)? = nil) where Presenting: View {
        
        self.presenting = AnyView(presenting)
        self._text = text
        self._actionText = actionText
        self.action = action
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.presenting
                VStack {
                    Spacer()
                    if let message = self.text {
                        HStack {
                            Text(message)
                                .foregroundColor(self.colorScheme == .light ? Color.white : Color.black)
                            Spacer()
                            if let actionMessage = self.actionText, self.action != nil {
                                Button(action: {
                                    self.action?()
                                    withAnimation {
                                        self.text = nil
                                        self.actionText = nil
                                    }
                                }) {
                                    Text(actionMessage)
                                        .bold()
                                        .foregroundColor(Color("AccentColor"))
                                }
                            }
                        }
                        .padding()
                        .frame(width: geometry.size.width * 0.9, height: 50)
                        .shadow(radius: 3)
                        .background(self.colorScheme == .light ? Color.black : Color.white)
                        .offset(x: 0, y: -20)
                        .transition(.asymmetric(insertion: .move(edge: .bottom),                                           removal: .move(edge: .bottom)))
                        .animation(Animation.spring())
                        .onAppear {
                            guard !self.isBeingDismissedByAction else { return }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    self.text = nil
                                    self.actionText = nil
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}



struct SnackbarView_Previews: PreviewProvider {
    static var previews: some View {
        SnackbarView(presenting: Text("presenting"),
                     text: .constant("Message"),
                     actionText: .constant("Action"),
                     action: {})
    }
}

extension View {
    
    func snackBar(text: Binding<String?>,
                  actionText: Binding<String?>? = nil,
                  action: (() -> Void)? = nil) -> some View {
        
        SnackbarView(presenting: self,
                     text: text,
                     actionText: actionText ?? .constant(nil),
                     action: action)
        
    }
    
}
