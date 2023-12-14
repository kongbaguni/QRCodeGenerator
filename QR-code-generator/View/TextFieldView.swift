//
//  TextFieldView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/14/23.
//

import SwiftUI

extension Notification.Name {
    static let textfieldSetFocus = Notification.Name("textfieldSetFocus_observer")
}

struct TextFieldView: View {
    enum InputType {
        case textfield
        case texteditor
    }
    
    let id:String
    let title:Text
    let placeHolder:Text?
    let inputType:InputType
    let keyboardType:UIKeyboardType
    
    @Binding var value:String
    @FocusState var focused:Bool
    
    var body: some View {
        HStack {
            title
            Group {
                switch inputType {
                case .textfield:
                    TextField(text: $value, prompt: placeHolder) {
                        Text("!!")
                    }

                case .texteditor:
                    TextEditor(text: $value)
                }
            }
            .focused($focused)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button {
                        UIApplication.shared.endEditing()
                    } label: {
                        Text("confirm")
                    }
                }
            }
            .keyboardType(keyboardType)
            .padding(5)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.black.opacity(0.2))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 1.0)
            }
        }
        .padding(.vertical,5)
        .onReceive(NotificationCenter.default.publisher(for: .textfieldSetFocus)) { noti in
            if id == noti.object as? String {
                focused = true
            }
        }
    }
}

#Preview {
    List {
        TextFieldView(
            id:"name",
            title: .init("name"),
            placeHolder: Text("input name"),
            inputType: .texteditor,
            keyboardType: .default,
            value: .constant(""))
        
        TextFieldView(
            id:"name",
            title: .init("name"),
            placeHolder: Text("input name"),
            inputType: .textfield,
            keyboardType: .default,
            value: .constant(""))
    }
}
