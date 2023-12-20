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
            keyPath: "updateDateTmeIntervalSince1970",
            ascending: false)
        
    ) var themeList
    
    @State var selected:[Bool] = []

    @AppStorage("selectThemeId") var selectThemeId:String = ""
    @State var isinited:Bool = false

    @State var error:Error? = nil
    @State var isAlert:Bool = false
    func refrashSelecton() {
        ThemeModel.sync { error in
            self.error = error
            
            selected.removeAll()
            for theme in themeList {
                let isSelected = selectThemeId == theme.id
                selected.append(isSelected)
            }
            isinited = selected.count == themeList.count
        }
       
    }

    func makeThemeItem(idx:Int, theme:ThemeModel)-> some View {
        NavigationLink {
            ThemeSettingView(themeId: theme.id)
        } label: {
            HStack {
                Text(theme.title)
                Spacer()
                if isinited {
                    Toggle(isOn: $selected[idx], label: {
                    })
                    .onChange(of: selected[idx]) { value in
                        if selected[idx] == true {
                            selectThemeId = theme.id
                        }
                        refrashSelecton()
                        NotificationCenter.default.post(name: .themeSettingChanged, object: nil)
                    }
                }
                
            }
        }
        
    }

    var body: some View {
        List {
            Group {
                if themeList.count > 0 && selected.count > 0 {
                    Section("themes") {
                        ForEach(0..<themeList.count, id:\.self) { idx in
                            let theme = themeList[idx]
                            makeThemeItem(idx: idx, theme:theme)
                        }
                    }
                }
                
                NavigationLink {
                    ThemeSettingView(themeId: nil)
                } label: {
                    RoundedTextView(text: .init("make new theme"), image: .init(systemName: "paintbrush.fill"), style: .normal)
                }
            }
            .listRowBackground(Color.themeBackground)
        }
        .onAppear {
            refrashSelecton()
        }
        .listStyle(.plain)
        .background(Color.themeBackground)

    }
        

}

#Preview {
    ThemeListView()
}
