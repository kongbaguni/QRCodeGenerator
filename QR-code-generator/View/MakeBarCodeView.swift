//
//  MakeBarCodeView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/24/23.
//

import SwiftUI
import RealmSwift

struct MakeBarCodeView: View {
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
    @State var foregroundColor:Color = .black
    @State var backgroundColor:Color = .white
    var body: some View {
        List {
            Section("Bar code") {
                CodeGenerator.makeBarcodeImage(
                    text: text,
                    forground: foregroundColor,
                    background: backgroundColor,
                    useCache: false
                )
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
            }
            Section("text input") {
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
                    .keyboardType(.asciiCapable)
            }
            
            Section("color") {
                ColorPicker("foreground Color", selection: $foregroundColor)
                ColorPicker("background Color", selection: $backgroundColor)
            }
            
            Section("tag input") {
                TagInputView(tagsString: $tags)
            }

                       
        }
        .navigationTitle(model == nil ? .init("make Bar code") : .init("edit Bar code"))
        .toolbar {
            Button {
                for tag in tags.components(separatedBy: ",") {
                    if tag.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
                        TagModel.addNewTag(text: tag) { error in
                            
                        }
                    }
                }
                if let model = model {
                    model.edit(inputType: .text, text: text, colors: (f: foregroundColor, b: backgroundColor), tags: tags) { error in
                        if error == nil {
                            DispatchQueue.main.async {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        self.error = error
                    }
                    return
                }
                CodeModel.add(codeType: .bar, inputType: .text, text: text, colors: (f: foregroundColor, b: backgroundColor), tags: tags.trimmingCharacters(in: .whitespacesAndNewlines)) { error in
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
            .init(title: .init("alert"),
                  message: .init(error!.localizedDescription))
        }
        .onAppear {
            if let model = model {
                text = model.text
                tags = model.tagsValue
                foregroundColor = model.foregroundColor
                backgroundColor = model.backgroundColor
            }
        }
    }
}

#Preview {
    MakeBarCodeView(id:nil)
}
