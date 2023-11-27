//
//  MakeQRCodeView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/24/23.
//

import SwiftUI

struct MakeQRCodeView: View {
    enum InputType : Int, CaseIterable {
        case text
        case mailto
        case https
        case http
        static var allTexts:[Text] {
            return InputType.allCases.map { type in
                switch type {
                case .text:
                    return .init("text")
                case .mailto:
                    return .init("mailto")
                case .https:
                    return .init("https")
                case .http:
                    return .init("http")
                }
            }
        }
    }
    
    @State var text:String = ""
    var outputText:String {
        switch InputType.allCases[tabIndex] {
        case .text:
            return text
        case .mailto:
            return "mailto:\(text)"
        case .https:
            return "https://\(text)"
        case .http:
            return "http://\(text)"
        }
    }
    @State var foregroundColor:Color = .black
    @State var backgroundColor:Color = .white
    @State var tabIndex = 0
    var body: some View {
        List {
            Section("QR code") {
                Text(outputText)
                CodeGenerator.makeQRImage(text: outputText, foreground: foregroundColor, background: backgroundColor)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }
            Section("text") {
                ScrollTabBarView(titles: InputType.allTexts, selectedIndex: $tabIndex)
                switch InputType(rawValue: tabIndex) {
                case .text:
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
                case .mailto:
                    HStack(spacing:0) {
                        Text("mailto:")
                        TextField("email", text: $text)
                            .keyboardType(.emailAddress)
                    }
                case .https:
                    HStack(spacing:0) {
                        Text("https://")
                        TextField("website", text: $text)
                            .keyboardType(.webSearch)
                    }
                case .http:
                    HStack(spacing:0) {
                        Text("http://")
                        TextField("website", text: $text)
                            .keyboardType(.webSearch)
                    }
                default:
                    Text("error")
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
