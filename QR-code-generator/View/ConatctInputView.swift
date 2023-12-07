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
            HStack {
                Text("name :")
                TextField("name", text:$fn)
                    .keyboardType(.default)
            }
            HStack {
                Text("phone :")
                TextField("phone", text:$tel)
            }
            HStack {
                Text("email :")
                TextField("email", text:$email)
                    .keyboardType(.emailAddress)
            }
            HStack {
                Text("organization name :")
                TextField("org", text:$org)
            }
            
        }
    }
}

#Preview {
    ContactInputView(fn: .constant(""), org: .constant(""), tel: .constant(""), email: .constant(""))
}
