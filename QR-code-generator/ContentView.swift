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
            CodeGenerator.makeQRImage(text: "QR code generator", colorA: .white, colorB: .green)
                .resizable()
                .scaledToFit()
            CodeGenerator.makeBarcodeImage(text: "bar code Generator", colorA: .blue, colorB: .white)
                .resizable()
                .scaledToFit()
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
