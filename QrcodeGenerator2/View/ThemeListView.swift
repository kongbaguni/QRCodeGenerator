//
//  ThemeListView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/15/23.
//

import SwiftUI
import RealmSwift

struct ThemeListView: View {
    @State var reTryAction:()->Void = {}
    @ObservedResults (
        ThemeModel.self,
        sortDescriptor: .init(
            keyPath: "updateDateTmeIntervalSince1970",
            ascending: false)
        
    ) var themeList
    
    @State var selected:[Bool] = []

    @AppStorage("showMyThemeOnly") var showMyThemeOnly = false
    
    @AppStorage("selectThemeId") var selectThemeId:String = ""
    @State var isinited:Bool = false

    @State var error:Error? = nil {
        didSet {
            if error != nil {
                isAlert = true
            }
        }
    }
    
    @State var isAlert:Bool = false
    func refrashSelecton() {
        func load() {
            selected.removeAll()
            for theme in themeList {
                let isSelected = selectThemeId == theme.id
                selected.append(isSelected)
            }
            isinited = selected.count == themeList.count
        }
        load()
        ThemeModel.sync { error in
            self.error = error
            load()
        }
       
    }

    func makeThemeItem(idx:Int, theme:ThemeModel)-> some View {
        NavigationLink {
            ThemeSettingView(themeId: theme.id)
        } label: {
            HStack {
                Text(theme.title)
                if theme.userId == AuthManager.shared.userId {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.themeSecondary)
                }
                Spacer()
                if isinited && selected.count == themeList.count {
                    Toggle(isOn: $selected[idx], label: {
                    })
                    .onChange(of: selected[idx]) { value in
                        if selected[idx] == true {
                            selectThemeId = theme.id
                        } else if selectThemeId == theme.id {         
                            selectThemeId = ""
                        }
                        refrashSelecton()
                        
                        ThemeModel.setTheme(id: selectThemeId) { error in
                            self.error = error
                            print(selectThemeId)

                        }
                        
                        NotificationCenter.default.post(name: .themeSettingChanged, object: selectThemeId)
                    }
                }
                
            }
        }
        
    }

    var body: some View {
        List {
            Group {
                Section {
                    Text("theme list desc")
                    if ThemeModel.myThemeCount > 0 && ThemeModel.myThemeCount != ThemeModel.totalCount {
                        Toggle(isOn: $showMyThemeOnly) {
                            Text("show my theme only")
                        }
                    }
                }
                if themeList.count > 0 && selected.count > 0 {
                    Section("themes") {
                        ForEach(0..<themeList.count, id:\.self) { idx in
                            let theme = themeList[idx]
                            if showMyThemeOnly {
                                if theme.userId == AuthManager.shared.userId {
                                    makeThemeItem(idx: idx, theme:theme)
                                } else {
                                    EmptyView()
                                }
                            } else {
                                makeThemeItem(idx: idx, theme:theme)
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
            .listRowBackground(Color.themeBackground)
        }
        .onAppear {
            if ThemeModel.myThemeCount == 0 {
                showMyThemeOnly = false 
            }
            refrashSelecton()
        }
        .listStyle(.plain)
        .background(Color.themeBackground)
        .alert(isPresented: $isAlert, content: {
            .init(title: .init("alert"), message: .init(error!.localizedDescription))
        })
        .navigationTitle(.init("theme list"))

    }
        

}

#Preview {
    ThemeListView()
}
