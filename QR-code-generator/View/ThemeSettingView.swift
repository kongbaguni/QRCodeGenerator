//
//  ThemeSettingView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/15/23.
//

import SwiftUI

struct ThemeSettingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var dark:ThemeColorSettingView.Colors = .init(
        backgroundColor: .black,
        primaryColor: .white,
        secondaryColor: .gray,
        textFieldForeground: .white,
        textFieldBackground: .orange,
        btn1Foreground: .black,
        btn1Background: .white,
        btn2Foreground: .orange,
        btn2Background: .white,
        btn3Foreground: .white,
        btn3Background: .teal
    )
    
    @State var light:ThemeColorSettingView.Colors = .init(
        backgroundColor: .teal.opacity(0.5),
        primaryColor: .black,
        secondaryColor: .gray,
        textFieldForeground: .red,
        textFieldBackground: .white,
        btn1Foreground: .white,
        btn1Background: .orange,
        btn2Foreground: .black,
        btn2Background: .white,
        btn3Foreground: .red,
        btn3Background: .yellow
    )
    
    @State var title:String = ""
    var body: some View {
        List {
            ThemeColorSettingView(colors: $dark, title: .init("dark mode"))
            
            ThemeColorSettingView(colors: $light, title: .init("light mode"))
            
            Section {
                TextFieldView(id: "title", title: .init("title"), placeHolder: .init("title input"), inputType: .textfield, keyboardType: .default, value: $title)
            }
            Section {
                Button {
                    save()
                } label: {
                    RoundedTextView(text: .init("save"), image: .init(systemName: "square.and.arrow.down"), style: .normal)
                }
            }

        }
        .navigationTitle(.init("make new theme"))
        .toolbar {
            Button(action: {
                save()
            }, label: {
                VStack {
                    Text("save")
                }
            })
        }
    }
    
    func save() {
        ThemeModel.create(title: title, dark: dark, light: light)
        presentationMode.wrappedValue.dismiss()        
    }
}

#Preview {
    NavigationView {
        ThemeSettingView()
    }
}
