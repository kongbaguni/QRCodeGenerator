//
//  ThemeSettingView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/15/23.
//

import SwiftUI
import RealmSwift

extension Notification.Name {
    static let themeSettingChanged = Notification.Name("themeSettingChanged_observer")
}

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
        backgroundColor: .init(red: 0.1, green: 0.2, blue: 0.3),
        primaryColor: .white,
        secondaryColor: .gray,
        textFieldForeground: .white,
        textFieldBackground: .orange,
        btn1Foreground: .black,
        btn1Background: .white,
        btn2Foreground: .orange,
        btn2Background: .white,
        btn3Foreground: .white,
        btn3Background: .teal,
        strong: .yellow
    )
    
    @State var light:ThemeColorSettingView.Colors = .init(
        backgroundColor: .init(red: 0.9, green: 0.95, blue: 0.98),
        primaryColor: .black,
        secondaryColor: .gray,
        textFieldForeground: .red,
        textFieldBackground: .white,
        btn1Foreground: .white,
        btn1Background: .orange,
        btn2Foreground: .black,
        btn2Background: .white,
        btn3Foreground: .red,
        btn3Background: .yellow,
        strong: .teal
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
        ScrollView {
            Section {
                TextFieldView(id: "title", title: .init("title"), placeHolder: .init("title input"), inputType: .textfield, keyboardType: .default, value: $title)
            }
            
            
            ThemeColorSettingView(colors: $dark, title: .init("dark mode"), readonly: themeModel?.userId != AuthManager.shared.userId && themeModel != nil)
            
            ThemeColorSettingView(colors: $light, title: .init("light mode"),
                                  readonly: themeModel?.userId != AuthManager.shared.userId && themeModel != nil)
            
            
            Section {
                if themeModel?.userId == AuthManager.shared.userId || themeModel == nil {
                    Button {
                        save()
                    } label: {
                        RoundedTextView(text: .init("save"), image: .init(systemName: "square.and.arrow.down"), style: .normal)
                    }
                }
            }
            
            if themeModel?.userId == AuthManager.shared.userId && themeModel != nil{
                Button {
                    error = CustomError.deleteTheme
                } label : {
                    RoundedTextView(text: .init("delete"), image: .init(systemName: "trash.circle"), style: .cancel)
                }
            }
        }
        .padding(20)
        .navigationTitle(
            themeId == nil 
            ? .init("make new theme")
            : themeModel?.userId == AuthManager.shared.userId
            ? .init("edit theme")
            : .init("theme preview")
        )
        .listStyle(.plain)
        .background(Color.themeBackground)

        .toolbar {
            if themeModel?.userId == AuthManager.shared.userId ||  themeModel == nil{
                Button(action: {
                    save()
                }, label: {
                    VStack {
                        Text("save")
                    }
                })
            }
        }
        .alert(isPresented: $isAlert, content: {
            switch error as? CustomError {
            case .deleteTheme:
                return .init(
                    title: .init("alert"),
                    message: .init(error!.localizedDescription),
                    primaryButton: .cancel(),
                    secondaryButton: .default(.init("delete"), action: {
                        themeModel?.delete(complete: { error in
                            self.error = error
                            if error == nil {
                                presentationMode.wrappedValue.dismiss()
                            }
                        })
                    }))
                
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
        ThemeModel.create(id: themeId,title: title, dark: dark, light: light) { error, id in
            if error == nil {
                NotificationCenter.default.post(name: .themeSettingChanged, object: id)
                presentationMode.wrappedValue.dismiss()
            }
            self.error = error

        }

    }
}

#Preview {
    NavigationView {
        ThemeSettingView(themeId:nil)
    }
}
