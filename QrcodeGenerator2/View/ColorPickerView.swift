//
//  ColorPickerView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/19/23.
//

import SwiftUI

struct ColorPickerView: View {
    let title1:Text
    let title2:Text?
    @Binding var foreground:Color
    @Binding var background:Color
    let onDisappear:()->Void

    var body: some View {
        List {
            Text("Preview")
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(title2 == nil ? .clear : background)
                    
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(foreground, lineWidth: 2.0)
                }
                .foregroundStyle(foreground, foreground.opacity(50), foreground.opacity(25))
            
            ColorPicker(selection: $foreground, label: {
                title1
            })
            
            if let title = title2 {
                ColorPicker(selection: $background, label: {
                    title
                })
            }
        }
        .navigationTitle(
            .init("color setting")
        )
        .onDisappear {
            DispatchQueue.main.async {
                onDisappear()
            }
            
        }
        
    }
}

#Preview {
    ColorPickerView(
        title1: .init("foreground"), 
        title2: .init("background"),
        foreground: .constant(.red), background: .constant(.teal)) {
            
        }
}
