//
//  AppTitleView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/24/23.
//

import SwiftUI

struct AppTitleView: View {
    var body: some View {
        VStack(spacing:0) {
            CodeGenerator.makeQRImage(text: "QR code", foreground: .teal, background: .clear, useCache: true)
                .resizable()
                .scaledToFit()
            CodeGenerator.makeBarcodeImage(text: "bar code", forground: .teal, background: .clear, useCache: true)
                .resizable()
                .scaledToFit()
            
            Text("App Title")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.teal)
            
        }
//        .shadow(color:.secondary,radius: 0, x:2, y:3)

        .padding(20)
        .background(.green.opacity(0.2))
        .cornerRadius(20)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.teal,lineWidth: 3)
        }
        .padding(20)
    }
}

#Preview {
    AppTitleView()
}
