//
//  ThemeManager.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/18/23.
//

import SwiftUI
import RealmSwift
struct ThemeManager {
    static let shared = ThemeManager()
    @AppStorage("selectThemeId") var selectThemeId:String = ""
    
    init() {
        NotificationCenter.default.addObserver(forName: .themeSettingChanged, object: nil, queue: nil) {[self] noti in
            if let id = noti.object as? String {
                selectThemeId = id
            }
        }
    }
    
    var themeModel:ThemeModel? {
        guard selectThemeId.isEmpty == false else {
            return nil
        }
        
        return Realm.shared.object(ofType: ThemeModel.self, forPrimaryKey: selectThemeId)
    }
    
    
    var background:Color {
        themeModel?.background?.color ?? .makeDynamicColor(light: .white, dark: .black)
    }
    var primary:Color {
        themeModel?.primary?.color ?? .primary
    }
    var secondary:Color {
        themeModel?.secondary?.color ?? .secondary
    }
    
    var btn1Background:Color {
        themeModel?.btn1Background?.color ?? .teal
    }
    var btn1Foreground:Color {
        themeModel?.btn1Foreground?.color ?? .primary
    }
    
    var btn2Background:Color {
        themeModel?.btn2Background?.color ?? .orange
    }
    var btn2Foreground:Color {
        themeModel?.btn2Foreground?.color ?? .primary
    }

    var btn3Background:Color {
        themeModel?.btn3Background?.color ?? .clear
    }
    var btn3Foreground:Color {
        themeModel?.btn3Foreground?.color ?? .secondary
    }

    
}

