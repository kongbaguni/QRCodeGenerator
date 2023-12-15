//
//  ThemeListView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/15/23.
//

import SwiftUI
import RealmSwift

struct ThemeListView: View {
    @ObservedResults (
        ThemeModel.self,
        sortDescriptor: .init(
            keyPath: "updateDt",
            ascending: false)
        
    ) var themeList

    var body: some View {
        List {  
            if themeList.count > 0 {
                Section("themes") {
                    ForEach(themeList, id:\.self) { theme in
                        NavigationLink {
                            ThemeSettingView(themeId: theme.id)
                        } label: {
                            Text(theme.title)
                        }
                        
                    }
                }
            }
            
            NavigationLink {
                ThemeSettingView(themeId: nil)
            } label: {
                RoundedTextView(text: .init("make new theme"), image: .init(systemName: "paintbrush.fill"), style: .normal)
            }

        }
        
    }
}

#Preview {
    ThemeListView()
}
