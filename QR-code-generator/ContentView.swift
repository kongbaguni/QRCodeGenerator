//
//  ContentView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/23/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Text("App Title")
            CodeGenerator.makeQRImage(text: "QR code generator", colorA: .orange, colorB: .white)
                .resizable()
                .scaledToFit()
            CodeGenerator.makeBarcodeImage(text: "bar code Generator", colorA: .orange, colorB: .white)
                .resizable()
                .scaledToFit()
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
