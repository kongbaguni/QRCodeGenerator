//
//  View+Extensions.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/19/23.
//

import Foundation
import SwiftUI
public extension View {
    func transparentScrolling() -> some View {
        if #available(iOS 16.0, *) {
            return scrollContentBackground(.hidden)
        } else {
            return onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
}
