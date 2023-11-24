//
//  MakeQRCodeView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/24/23.
//

import SwiftUI

struct MakeQRCodeView: View {
    @State var text:String = ""
    @State var foregroundColor:Color = .black
    @State var backgroundColor:Color = .white
    var body: some View {
        List {
            Section("QR code") {
                CodeGenerator.makeQRImage(text: text, foreground: foregroundColor, background: backgroundColor)
                    .resizable()
                    .scaledToFit()
            }
            Section("text") {
                TextEditor(text: $text)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Button {
                                UIApplication.shared.endEditing()
                            } label: {
                                Text("confirm")
                            }
                        }
                    }
            }
            Section("color") {
                ColorPicker("foreground Color", selection: $foregroundColor)
                ColorPicker("background Color", selection: $backgroundColor)
            }
           
            
        }.navigationTitle(.init("make QR code"))
    }
}

#Preview {
    MakeQRCodeView()
}
