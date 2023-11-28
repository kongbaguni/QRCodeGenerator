//
//  MakeBarCodeView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/24/23.
//

import SwiftUI

struct MakeBarCodeView: View {
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
                CodeGenerator.makeBarcodeImage(text: text, forground: foregroundColor, background: backgroundColor)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
            }
            
            Section("text") {
                TagInputView(tags: TagModel.tags, tagsString: $tags)
                
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
                       
        }
        .navigationTitle(.init("make Bar code"))
        .toolbar {
            Button {
                for tag in tags.components(separatedBy: ",") {
                    if tag.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
                        TagModel.addNewTag(text: tag) { error in
                            
                        }
                    }
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
    }
}

#Preview {
    MakeBarCodeView()
}
