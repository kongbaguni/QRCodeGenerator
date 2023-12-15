//
//  ThemeListView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/15/23.
//

import SwiftUI

struct ThemeListView: View {
    var body: some View {
        List {        
            NavigationLink {
                ThemeSettingView()
            } label: {
                RoundedTextView(text: .init("make new theme"), image: .init(systemName: "paintbrush.fill"), style: .normal)
            }

        }
        
    }
}

#Preview {
    ThemeListView()
}
