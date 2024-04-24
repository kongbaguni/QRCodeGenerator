//
//  DeleteAccountConfirmView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/7/23.
//

import SwiftUI

struct DeleteAccountConfirmView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let accountModel:AccountModel
    @State var text:String = ""
    @State var test:Bool = false
    
    @State var error:Error? = nil {
        didSet {
            if error != nil {
                isAlert = true
            }
        }
    }
    @State var isAlert:Bool = false
    
    var body: some View {
        List {
            Group {
                HStack {
                    Spacer()
                    Image(systemName: "person.text.rectangle.fill")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(height: 200)
                        .foregroundStyle(.blue,.yellow,.teal)
                    Image(systemName: "arrow.right")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .foregroundStyle(.teal)
                    Image(systemName: "trash")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .foregroundStyle(.red)
                    Spacer()
                    
                }
                Text("delete account desc1")
                
                TextFieldView(id: "confirm", title: .init("input"), placeHolder: .init(accountModel.email ?? accountModel.userId), inputType: .textfield, keyboardType: .default, value: $text)
                    .onChange(of: text) { text in
                        test = accountModel.email ?? accountModel.userId == text.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                
                Button {
                    AuthManager.shared.leave { error in
                        self.error = error
                        if error == nil {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                } label: {
                    Text("confirm")
                }.disabled(!test)
            }
            .listRowBackground(Color.themeBackground)
                        
        }
        .listStyle(.plain)
        .background(Color.themeBackground)
        .navigationTitle(.init("delete account"))
        .onAppear {
            #if DEBUG
            text = accountModel.email ?? accountModel.userId
            #endif
        }
        .alert(isPresented: $isAlert) {
            .init(title: .init("alert"),
                  message: .init(error!.localizedDescription))
        }
    }
}

#Preview {
    NavigationView {
        DeleteAccountConfirmView(accountModel: .init(userId: "test", accountRegDt: Date(), accountLastSigninDt: Date(), email: "test@gmail.com", phoneNumber: nil, photoURL: nil, isAnonymous: false))
    }.navigationViewStyle(.stack)
}
