//
//  ThemeSettingView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/15/23.
//

import SwiftUI
import RealmSwift

struct ThemeSettingView: View {
    let themeId:String?

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var themeModel:ThemeModel? {
        if let id = themeId {
            return Realm.shared.object(ofType: ThemeModel.self, forPrimaryKey: id)
        }
        return nil
    }

    @State var dark:ThemeColorSettingView.Colors = .init(
        backgroundColor: .red,
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
    
    @State var isLoaded:Bool = false
    
    @State var title:String = ""
    @State var error:Error? = nil {
        didSet {
            if error != nil {
                isAlert = true
            }
        }
    }
    
    @State var isAlert:Bool = false
    
    func load() {
        if isLoaded {
            return
        }
        guard let model = themeModel else {
            return
        }
        dark = model.dark
        light = model.light
        title = model.title
        isLoaded = true
    }
    
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
        .alert(isPresented: $isAlert, content: {
            switch error as? CustomError {
            case .emptyTitle:
                return .init(
                    title: .init("alert"),
                    message: .init(error!.localizedDescription),
                    dismissButton: .default(.init("confirm"), action: {
                        NotificationCenter.default.post(name: .textfieldSetFocus, object: "title")
                    })
                )
            default:
                return .init(
                    title: .init("alert"),
                    message: .init(error!.localizedDescription))

            }
        })
        .onAppear {
            load()
        }
    }
    
    func save() {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            error = CustomError.emptyTitle
            return
        }
        ThemeModel.create(id: themeId,title: title, dark: dark, light: light)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NavigationView {
        ThemeSettingView(themeId:nil)
    }
}
