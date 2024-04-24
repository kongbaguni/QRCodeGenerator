//
//  MakeQRCodeView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/24/23.
//

import SwiftUI
import RealmSwift


struct MakeQRCodeView: View {
    let id:String?
    var model:CodeModel? {
        if let id = id {
            return Realm.shared.object(ofType: CodeModel.self, forPrimaryKey: id)
        }
        return nil
    }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    @State var error:Error? = nil {
        didSet {
            if error != nil {
                isAlert = true
            }
        }
    }
    
    @State var isAlert:Bool = false
   
    
    @State var text:String = ""
    
    @State var c_fn:String = ""
    @State var c_org:String = ""
    @State var c_tel:String = ""
    @State var c_email:String = ""
    
    @State var tags:String = ""
    
    
    var outputText:String {
        let inputType = CodeModel.InputType.allCases[tabIndex]
        switch inputType {
        case .contact:
            return ContactModel(fn: c_fn, org: c_org, tel: c_tel, email: c_email).vCardString
        default:
            return inputType.makeOutputString(text: text)
        }
    }
    
    @State var foregroundColor:Color = .black
    @State var backgroundColor:Color = .white
    @State var tabIndex = 0
    
    var inputType:CodeModel.InputType {
        CodeModel.InputType(rawValue: tabIndex) ?? .text
    }
    
    var inputTest:CustomError? {
        let c = [
            text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            c_fn.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            c_tel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        ]
        
        switch inputType {
        case .contact:
            if c[1] {
                return .emptyName
            }
            if c[2] {
                return .emptyPhoneNumber
            }
                                        
        default:
            if c[0] {
                return .emptyText
            }
            
        }
        return nil
    }
    
    var body: some View {
        List {
            Group {
                Section("QR code") {
                    VStack {
                        CodeGenerator.makeQRImage(text: outputText, foreground: foregroundColor, background: backgroundColor, useCache: false)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                        Text(outputText)
                            .foregroundStyle(foregroundColor)
                        
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(backgroundColor)
                    )
                    .overlay{
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(foregroundColor, lineWidth:2)
                    }
                    .padding(10)
                }
                Section("text input") {
                    ScrollTabBarView(titles: CodeModel.InputType.allTexts, selectedIndex: $tabIndex)
                    switch CodeModel.InputType(rawValue: tabIndex) {
                    case .text:
                        TextFieldView(
                            id: "code",
                            title: .init("text input"),
                            placeHolder: .init("text input placeholder"),
                            inputType: .texteditor,
                            keyboardType: .default,
                            value: $text)
                        
                    case .mailto:
                        TextFieldView(
                            id: "code",
                            title: .init("mailto:"),
                            placeHolder: .init("email"),
                            inputType: .textfield,
                            keyboardType: .emailAddress,
                            value: $text)
                        
                    case .https:
                        TextFieldView(
                            id: "code",
                            title: .init("https://"),
                            placeHolder: .init("website"),
                            inputType: .textfield,
                            keyboardType: .URL,
                            value: $text)
                        
                    case .http:
                        TextFieldView(
                            id: "code",
                            title: .init("http://"),
                            placeHolder: .init("website"),
                            inputType: .textfield,
                            keyboardType: .URL,
                            value: $text)
                        
                    case .facebook:
                        TextFieldView(
                            id: "code",
                            title: .init("facebook.com/"),
                            placeHolder: .init("facebook id"),
                            inputType: .textfield,
                            keyboardType: .default,
                            value: $text)
                        
                    case .instagram:
                        TextFieldView(
                            id: "code",
                            title: .init("instagram.com/"),
                            placeHolder: .init("instagram id"),
                            inputType: .textfield,
                            keyboardType: .default,
                            value: $text)
                        
                    case .x:
                        TextFieldView(
                            id: "code",
                            title: .init("x.com/"),
                            placeHolder: .init("X id"),
                            inputType: .textfield,
                            keyboardType: .twitter,
                            value: $text)
                        
                    case .youtube:
                        TextFieldView(
                            id: "code",
                            title: .init("youtube.com/"),
                            placeHolder: .init("youtube id"),
                            inputType: .textfield,
                            keyboardType: .default,
                            value: $text)
                        
                    case .phonenumber:
                        TextFieldView(
                            id: "code",
                            title: .init("tel:"),
                            placeHolder: .init("phonenumber"),
                            inputType: .textfield,
                            keyboardType: .default,
                            value: $text)
                        
                    case .contact:
                        ContactInputView(fn: $c_fn, org: $c_org, tel: $c_tel, email: $c_email)
                        
                    default:
                        Text("error")
                    }
                }
                
                Section("color") {
                    ColorPicker("foreground Color", selection: $foregroundColor)
                    ColorPicker("background Color", selection: $backgroundColor)
                }
                
                Section("tag input") {
                    TagInputView(tagsString: $tags)
                }
                Section("ad") {
                    NativeAdView()
                }
            }
            .listRowBackground(Color.themeBackground)
        }
        .listStyle(.plain)
        .background(Color.themeBackground)

        .navigationTitle(model == nil ? .init("make QR code") : .init("edit QR code"))
        .toolbar {
            Button {
                if let err = inputTest {
                    self.error = err
                    return
                }
                
                TagModel.addNewTags(text: tags) { progress in
                    
                } complete: { error in
                    
                }
                
                var text = text
                if CodeModel.InputType(rawValue: tabIndex) == .contact {
                    text = outputText
                }
                
                if let model = model {
                    
                    model.edit(inputType: inputType, text: text, colors: (f: foregroundColor, b: backgroundColor), tags: tags) { error in
                        self.error = error
                        if error == nil {
                            DispatchQueue.main.async {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                    return
                }

            
                
                CodeModel.add(
                    codeType: .qr,
                    inputType: CodeModel.InputType(rawValue: tabIndex)
                    ?? .text,
                    text: text,
                    colors: (f:foregroundColor,b:backgroundColor),
                    tags:tags
                
                ) { error in
                        if error == nil {
                            presentationMode.wrappedValue.dismiss()
                        }
                        self.error = error
                    }
            } label : {
                Text("save")
            }
        }
        .alert(isPresented: $isAlert) {
            switch error as? CustomError {
            case .notEnoughPoint:
                return .init(
                    title: .init("alert"),
                    message: .init(error!.localizedDescription), primaryButton: .default(.init("watch ad"), action: {
                        GoogleAd.shared.showAd { error in
                            self.error = error
                        }
                    }), secondaryButton: .cancel())
            case .emptyText, .emptyName:
                return .init(
                    title: .init("alert"),
                    message : .init(error!.localizedDescription),
                    dismissButton: .default(.init("confirm"), action: {
                        NotificationCenter.default.post(name: .textfieldSetFocus, object: "code")
                    })
                )
            case .emptyPhoneNumber:
                return .init(
                    title: .init("alert"),
                    message : .init(error!.localizedDescription),
                    dismissButton: .default(.init("confirm"), action: {
                        NotificationCenter.default.post(name: .textfieldSetFocus, object: "phone")
                    })
                )
                
            default:
                return .init(title: .init("alert"), message: .init(error!.localizedDescription))

            }
        }
        .onAppear {
            if let model = model {
                print(model.text)
                text = model.text
                tags = model.tagsValue
                tabIndex = model.inputTypeValue
                foregroundColor = model.foregroundColor
                backgroundColor = model.backgroundColor
                if model.inputType == .contact {
                    if let cm = ContactModel.parseVCard(vCardString: model.text) {
                        c_fn = cm.fn
                        c_org = cm.org
                        c_tel = cm.tel
                        c_email = cm.email
                        text = ""
                    }
                }
            }
        }
    }
}

#Preview {
    MakeQRCodeView(id:nil)
}
