//
//  CheckboxView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/24/23.
//

import SwiftUI

struct CheckboxView: View {
    @Binding var isOn:Bool
    let label:Text
    
    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack {
                Image(systemName: isOn ? "checkmark.square" : "square")
                    .foregroundStyle(isOn ? .primary : .secondary,  .secondary)
                label
            }
        }
            
    }
}

#Preview {
    VStack {
        CheckboxView(isOn: .constant(false), label: .init("test"))
        CheckboxView(isOn: .constant(true), label: .init("test"))
    }
}
