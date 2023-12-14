//
//  ConatctEditView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/7/23.
//

import SwiftUI

struct ContactInputView : View {
    /** 이름*/
    @Binding var fn:String
    /** 회사*/
    @Binding var org:String
    /** 전화번호*/
    @Binding var tel:String
    /** 이메일*/
    @Binding var email:String
    
    var body: some View {
        VStack {
            TextFieldView(
                id: "code",
                title: .init("name"),
                placeHolder: .init("name"),
                inputType: .textfield,
                keyboardType: .default,
                value: $fn)

            TextFieldView(
                id: "phone",
                title: .init("phone"),
                placeHolder: .init("010-1234-1234"),
                inputType: .textfield,
                keyboardType: .phonePad,
                value: $tel)

            TextFieldView(
                id: "email",
                title: .init("email"),
                placeHolder: .init("email"),
                inputType: .textfield,
                keyboardType: .emailAddress,
                value: $email)

            TextFieldView(
                id: "org",
                title: .init("organization name"),
                placeHolder: .init("org"),
                inputType: .textfield,
                keyboardType: .default,
                value: $org)
            
        }
    }
}

#Preview {
    ContactInputView(fn: .constant(""), org: .constant(""), tel: .constant(""), email: .constant(""))
}
