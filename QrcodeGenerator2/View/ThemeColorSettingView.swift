//
//  ThemeColorSettingView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/15/23.
//

import SwiftUI

struct ThemeColorSettingView: View {
    
    @Binding var colors:ThemeModel.Colors
    let title:Text

    let readonly:Bool
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
    @State var strong:Color = .yellow

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
        strong = colors.strong
        isLoadFirst = true
    }
    
    func apply() {
        colors = .init(
            backgroundColor: backgroundColor,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            textFieldForeground: textFieldForeground,
            textFieldBackground: textFieldBackground,
            btn1Foreground: btn1Foreground,
            btn1Background: btn1background,
            btn2Foreground: btn2Foreground,
            btn2Background: btn2background,
            btn3Foreground: btn3Foreground,
            btn3Background: btn3background,
            strong: strong
        )
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
    var previewReadOnly : some View {
        VStack {
            Group {
                Text("primary").foregroundStyle(primaryColor)
                
                Text("secondary").foregroundStyle(secondaryColor)

                Text("strong").foregroundStyle(strong)
            }
            .font(.system(size: 20))
            .padding(10)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.themeBtn1Foreground, lineWidth: 2)
            }
            .padding(5)
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
    
    var preview : some View {
        VStack {
            Group {
                NavigationLink {
                    ColorPickerView(title1: .init("primary"), title2: nil, foreground: $primaryColor, background: $primaryColor) {
                        apply()
                    }
                    
                } label: {
                    Text("primary").foregroundStyle(primaryColor)
                }

                NavigationLink {
                    ColorPickerView(title1: .init("secondary"), title2: nil, foreground: $secondaryColor, background: $secondaryColor) {
                        apply()
                    }
                } label: {
                    Text("secondary").foregroundStyle(secondaryColor)
                }

                NavigationLink {
                    ColorPickerView(
                        title1: .init("strong"),
                        title2: nil,
                        foreground: $strong,
                        background: $strong) {
                            apply()
                        }
                } label: {
                    Text("strong").foregroundStyle(strong)
                }
            }
            .font(.system(size: 20))
            .padding(10)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.themeBtn1Foreground, lineWidth: 2)
            }
            .padding(5)
            NavigationLink {
                ColorPickerView(
                    title1: .init("textField foreground"),
                    title2: .init("textField background"),
                    foreground: $textFieldForeground,
                    background: $textFieldBackground) {
                        apply()
                    }
            } label: {
                makeTextField(title: "empty textField", text: "")
                makeTextField(title: "textField", text: "textField")
            }

                    
            HStack {
                NavigationLink {
                    ColorPickerView(
                        title1: .init("foreground"),
                        title2: .init("background"),
                        foreground: $btn1Foreground,
                        background: $btn1background) {
                            apply()
                        }
                } label: {
                    makeButton(text: .init("btn1"), background: btn1background, foreground: btn1Foreground)
                }

                NavigationLink {
                    ColorPickerView(
                        title1: .init("foreground"),
                        title2: .init("background"),
                        foreground: $btn2Foreground,
                        background: $btn2background) {
                            apply()
                        }
                } label: {
                    makeButton(text: .init("btn2"), background: btn2background, foreground: btn2Foreground)
                }
                
                NavigationLink {
                    ColorPickerView(
                        title1: .init("foreground"),
                        title2: .init("background"),
                        foreground: $btn3Foreground,
                        background: $btn3background) {
                            apply()
                        }
                } label: {
                    makeButton(text: .init("btn3"), background: btn3background, foreground: btn3Foreground)
                }
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
                .onChange(of: backgroundColor, perform: { value in
                    apply()
                })
            ColorPicker("primary color", selection: $primaryColor)
                .onChange(of: primaryColor, perform: { value in
                    apply()
                })
            ColorPicker("secondary color", selection: $secondaryColor)
                .onChange(of: secondaryColor, perform: { value in
                    apply()
                })
            
            ColorPicker("strong color", selection: $strong)
                .onChange(of: strong, perform: { value in
                    apply()
                })

            ColorPicker("textfield background color", selection: $textFieldBackground)
                .onChange(of: textFieldBackground, perform: { value in
                    apply()
                })
            ColorPicker("textfiled foreground color", selection: $textFieldForeground)
                .onChange(of: textFieldForeground, perform: { value in
                    apply()
                })
            
            ColorPicker("btn1 foreground color", selection: $btn1Foreground)
                .onChange(of: btn1background, perform: { value in
                    apply()
                })
            ColorPicker("btn1 background color", selection: $btn1background)
                .onChange(of: btn1Foreground, perform: { value in
                    apply()
                })
            ColorPicker("btn2 foreground color", selection: $btn2Foreground)
                .onChange(of: btn2Foreground, perform: { value in
                    apply()
                })
            ColorPicker("btn2 background color", selection: $btn2background)
                .onChange(of: btn2background, perform: { value in
                    apply()
                })
            ColorPicker("btn3 foreground color", selection: $btn3Foreground)
                .onChange(of: btn3Foreground, perform: { value in
                    apply()
                })
            ColorPicker("btn3 background color", selection: $btn3background)
                .onChange(of: btn3background, perform: { value in
                    apply()
                })
            
        }
    }
    var body: some View {
        Section {
            if readonly {
                previewReadOnly
            }
            else {
                ScrollView(.horizontal) {
                    HStack {
                        preview
                            .frame(width:250)
                        VStack {
                            settingView
                        }
                    }
                }
                .padding(5)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.primary, lineWidth: 2)
                }
                .padding(5)
            }
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
                btn3Background: .brown,
                strong: .yellow
            )), title: .init("dark mode"), readonly: false)
        }
    }
}
