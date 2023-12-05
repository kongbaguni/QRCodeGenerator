//
//  QRCodeView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/5/23.
//

import SwiftUI
import RealmSwift

struct CodeView: View {
    @ObservedRealmObject var code:CodeModel
    var body: some View {
        VStack {
            code.image
                .resizable()
                .scaledToFit()            
            Text(code.text)
                .foregroundStyle(code.foregroundColor)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(code.backgroundColor)
        )
        .overlay{
            RoundedRectangle(cornerRadius: 20)
                .stroke( code.foregroundColor, lineWidth: 2)
        }
    }
}

#Preview {
    VStack {
        let data:[String:AnyHashable] = [
            "id":"123asdjkl",
            "text":"text",
            "tagsValue":"ㅋㅋㅋ,바보",
            "codeTypeValue":1,
            "inputTypeValue":1,
            "foregroundColorRed":1,
            "foregroundColorGreen":1,
            "foregroundColorBlue":1,
            "foregroundColorAlpha":1,
            "backgroundColorRed":0.5,
            "backgroundColorGreen":0.3,
            "backgroundColorBlue":0.9,
            "backgroundColorAlpha":1.0,
        ]
        CodeView(code: .init(value: data))
    }
}
