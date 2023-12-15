//
//  ThemeColorSettingView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/15/23.
//

import SwiftUI

struct ThemeColorSettingView: View {
    struct Colors {
        let backgroundColor:Color
        let primaryColor:Color
        let secondaryColor:Color
        let textFieldForeground:Color
        let textFieldBackground:Color
        let btn1Foreground:Color
        let btn1Background:Color
        let btn2Foreground:Color
        let btn2Background:Color
        let btn3Foreground:Color
        let btn3Background:Color
    }
    @Binding var colors:Colors
    let title:Text

    @State var backgroundColor:Color = .black
    @State var primaryColor:Color = .white
    @State var secondaryColor:Color = .gray
    @State var textFieldForeground:Color = .yellow
    @State var textFieldBackground:Color = .teal
    @State var btn1Foreground:Color = .white
    @State var btn1background:Color = .black
    @State var btn2Foreground:Color = .white
    @State var btn2background:Color = .black
    @State var btn3Foreground:Color = .white
    @State var btn3background:Color = .black

    @State var test:String = ""

    @State var isLoadFirst:Bool = false
    func load() {
        if isLoadFirst {
            return
        }
        backgroundColor = colors.backgroundColor
        primaryColor = colors.primaryColor
        secondaryColor = colors.secondaryColor
        textFieldForeground = colors.textFieldForeground
        textFieldBackground = colors.textFieldBackground
        btn1background = colors.btn1Background
        btn1Foreground = colors.btn1Foreground
        btn2background = colors.btn2Background
        btn2Foreground = colors.btn2Foreground
        btn3background = colors.btn3Background
        btn3Foreground = colors.btn3Foreground
        isLoadFirst = true
    }
    
    func makeTextField(title:String, text:String)-> some View {
        if #available(iOS 17.0, *) {
            return TextField(title, text: .constant(text), prompt: .init(title).foregroundStyle(textFieldForeground.opacity(0.5))
            )
            
                .padding(10)
                .foregroundStyle(textFieldForeground)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(textFieldBackground)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(textFieldForeground, lineWidth: 2)
                }
        } else {
            return TextField(title, text: .constant(text))
                .padding(10)
                .foregroundStyle(textFieldForeground)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(textFieldBackground)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(textFieldForeground, lineWidth: 2)
                }
        }

    }
    
    func makeButton(text:Text,background:Color,foreground:Color) -> some View  {
        HStack {
            Image(systemName: "theatermask.and.paintbrush")
                .resizable()
                .scaledToFit()
                .foregroundStyle(foreground, foreground.opacity(0.4))
            
            text
                .foregroundStyle(foreground)
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(background)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(foreground, lineWidth: 2)
        }
    }
    
    var preview : some View {
        VStack {
            Group {
                Text("primary")
                    .foregroundStyle(primaryColor)
                Text("secondary")
                    .foregroundStyle(secondaryColor)
            }
            .font(.system(size: 20))
            makeTextField(title: "empty textField", text: "")

            makeTextField(title: "textField", text: "textField")
            
        
            HStack {
                makeButton(text: .init("btn1"), background: btn1background, foreground: btn1Foreground)
                makeButton(text: .init("btn2"), background: btn2background, foreground: btn2Foreground)
                makeButton(text: .init("btn3"), background: btn3background, foreground: btn3Foreground)
            }
                
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(backgroundColor)
        }
        .onAppear {
            load()
        }
    }
    
    var settingView : some View {
        Group {
            ColorPicker("background color", selection: $backgroundColor)
            ColorPicker("primary color", selection: $primaryColor)
            ColorPicker("secondary color", selection: $secondaryColor)
            ColorPicker("textfield background color", selection: $textFieldBackground)
            ColorPicker("textfiled foreground color", selection: $textFieldForeground)
            
            ColorPicker("btn1 foreground color", selection: $btn1Foreground)
            ColorPicker("btn1 background color", selection: $btn1background)

            ColorPicker("btn2 foreground color", selection: $btn2Foreground)
            ColorPicker("btn2 background color", selection: $btn2background)

            ColorPicker("btn3 foreground color", selection: $btn3Foreground)
            ColorPicker("btn3 background color", selection: $btn3background)
            
        }
    }
    var body: some View {
        Section {
            preview
            settingView
        } header: {
            title
        }
    }
}

#Preview {
    NavigationView {
        List {
            ThemeColorSettingView(colors:.constant(.init(
                backgroundColor: .teal.opacity(0.5),
                primaryColor: .black,
                secondaryColor: .orange,
                textFieldForeground: .black,
                textFieldBackground: .white,
                btn1Foreground: .blue,
                btn1Background: .yellow,
                btn2Foreground: .black,
                btn2Background: .orange,
                btn3Foreground: .white,
                btn3Background: .brown
            )), title: .init("dark mode"))
        }
    }
}
