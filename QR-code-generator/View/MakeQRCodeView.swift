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
    @State var tags:String = ""
    
    var outputText:String {
        CodeModel.InputType.allCases[tabIndex].makeOutputString(text: text)
    }
    
    @State var foregroundColor:Color = .black
    @State var backgroundColor:Color = .white
    @State var tabIndex = 0
    
    var inputType:CodeModel.InputType {
        CodeModel.InputType(rawValue: tabIndex) ?? .text
    }
    
    var body: some View {
        List {
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
                .padding(10)
            }
            Section("text input") {
                ScrollTabBarView(titles: CodeModel.InputType.allTexts, selectedIndex: $tabIndex)
                switch CodeModel.InputType(rawValue: tabIndex) {
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
                case .facebook:
                    HStack(spacing:0) {
                        Text("facebook.com/")
                        TextField("facebook id", text: $text)
                            .keyboardType(.webSearch)
                    }
                case .instagram:
                    HStack(spacing:0) {
                        Text("instagram.com/")
                        TextField("instagram id", text: $text)
                            .keyboardType(.webSearch)
                    }
                case .x:
                    HStack(spacing:0) {
                        Text("x.com/")
                        TextField("X id", text: $text)
                            .keyboardType(.webSearch)
                    }
                case .youtube:
                    HStack(spacing:0) {
                        Text("youtube.com/")
                        TextField("youtube id", text: $text)
                            .keyboardType(.webSearch)
                    }
                case .phonenumber:
                    HStack(spacing:0) {
                        Text("tel:")
                        TextField("phonenumber", text: $text)
                            .keyboardType(.phonePad)
                    }
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

                       
        }
        .navigationTitle(model == nil ? .init("make QR code") : .init("edit QR code"))
        .toolbar {
            Button {
                TagModel.addNewTags(text: tags) { progress in
                    
                } complete: { error in
                    
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
            .init(title: .init("alert"), message: .init(error!.localizedDescription))
        }
        .onAppear {
            if let model = model {
                text = model.text
                tags = model.tagsValue
                tabIndex = model.inputTypeValue
                foregroundColor = model.foregroundColor
                backgroundColor = model.backgroundColor
            }
        }
    }
}

#Preview {
    MakeQRCodeView(id:nil)
}
