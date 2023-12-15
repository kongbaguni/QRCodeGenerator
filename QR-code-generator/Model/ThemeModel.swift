//
//  ThemeModel.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/15/23.
//

import Foundation
import RealmSwift
import SwiftUI

class ThemeModel : Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id:String = ""
    @Persisted var title:String = ""
    
    @Persisted var background:DynamicColorModel?
    @Persisted var primary:DynamicColorModel?
    @Persisted var secondary:DynamicColorModel?
    @Persisted var textFieldBackground:DynamicColorModel?
    @Persisted var textFieldForeground:DynamicColorModel?
    
    @Persisted var btn1Background:DynamicColorModel?
    @Persisted var btn1Foreground:DynamicColorModel?
    @Persisted var btn2Background:DynamicColorModel?
    @Persisted var btn2Foreground:DynamicColorModel?
    @Persisted var btn3Background:DynamicColorModel?
    @Persisted var btn3Foreground:DynamicColorModel?
    
    @Persisted var regDt:Date = Date()
    @Persisted var updateDt:Date = Date()
}

extension ThemeModel {
    static func create(title:String, dark:ThemeColorSettingView.Colors, light:ThemeColorSettingView.Colors) {    
        let value:[String:AnyHashable] = [
            "id" : "\(UUID().uuidString):\(Date().timeIntervalSince1970)",
            "title" : title,
            "background" : ColorModel.makeColor(light: light.backgroundColor, dark: dark.backgroundColor),
            "primary" : ColorModel.makeColor(light: light.primaryColor, dark: dark.primaryColor),
            "secondary" : ColorModel.makeColor(light: light.secondaryColor, dark: dark.secondaryColor),
            "textFieldBackground" : ColorModel.makeColor(light: light.textFieldBackground, dark: dark.textFieldBackground),
            "textFieldForeground" : ColorModel.makeColor(light: light.textFieldForeground, dark: dark.textFieldForeground),
            "btn1Background" : ColorModel.makeColor(light: light.btn1Background, dark: dark.btn1Background),
            "btn1Foreground" : ColorModel.makeColor(light: light.btn1Foreground, dark: dark.btn1Foreground),
            "btn2Background" : ColorModel.makeColor(light: light.btn2Background, dark: dark.btn2Background),
            "btn2Foreground" : ColorModel.makeColor(light: light.btn2Foreground, dark: dark.btn2Foreground),
            "btn3Background" : ColorModel.makeColor(light: light.btn3Background, dark: dark.btn3Background),
            "btn3Foreground" : ColorModel.makeColor(light: light.btn3Foreground, dark: dark.btn3Foreground),
            "regDt" : Date(),
            "updateDt" : Date()
        ]
        
        let realm = Realm.shared
        realm.beginWrite()
        realm.create(ThemeModel.self, value: value, update: .all)
        try! realm.commitWrite()
    }
}
