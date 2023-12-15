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
    static func create(id:String?, title:String, dark:ThemeColorSettingView.Colors, light:ThemeColorSettingView.Colors) {
        let value:[String:AnyHashable] = [
            "id" : id ?? "\(UUID().uuidString):\(Date().timeIntervalSince1970)",
            "title" : title,
            "background" : DynamicColorModel.makeColor(light: light.backgroundColor, dark: dark.backgroundColor),
            "primary" : DynamicColorModel.makeColor(light: light.primaryColor, dark: dark.primaryColor),
            "secondary" : DynamicColorModel.makeColor(light: light.secondaryColor, dark: dark.secondaryColor),
            "textFieldBackground" : DynamicColorModel.makeColor(light: light.textFieldBackground, dark: dark.textFieldBackground),
            "textFieldForeground" : DynamicColorModel.makeColor(light: light.textFieldForeground, dark: dark.textFieldForeground),
            "btn1Background" : DynamicColorModel.makeColor(light: light.btn1Background, dark: dark.btn1Background),
            "btn1Foreground" : DynamicColorModel.makeColor(light: light.btn1Foreground, dark: dark.btn1Foreground),
            "btn2Background" : DynamicColorModel.makeColor(light: light.btn2Background, dark: dark.btn2Background),
            "btn2Foreground" : DynamicColorModel.makeColor(light: light.btn2Foreground, dark: dark.btn2Foreground),
            "btn3Background" : DynamicColorModel.makeColor(light: light.btn3Background, dark: dark.btn3Background),
            "btn3Foreground" : DynamicColorModel.makeColor(light: light.btn3Foreground, dark: dark.btn3Foreground),
            "regDt" : Date(),
            "updateDt" : Date()
        ]
        
        let realm = Realm.shared
        realm.beginWrite()
        realm.create(ThemeModel.self, value: value, update: .all)
        try! realm.commitWrite()
    }
    
    var dark:ThemeColorSettingView.Colors {
        .init(
            backgroundColor: background?.dark?.color ?? .black,
            primaryColor: primary?.dark?.color ?? .white,
            secondaryColor: secondary?.dark?.color ?? .gray,
            textFieldForeground: textFieldForeground?.dark?.color ?? .black,
            textFieldBackground: textFieldBackground?.dark?.color ?? .white,
            btn1Foreground: btn1Foreground?.dark?.color ?? .black,
            btn1Background: btn1Background?.dark?.color ?? .white,
            btn2Foreground: btn2Foreground?.dark?.color ?? .black,
            btn2Background: btn2Background?.dark?.color ?? .white,
            btn3Foreground: btn3Foreground?.dark?.color ?? .black,
            btn3Background: btn3Background?.dark?.color ?? .black)
    }
    
    var light:ThemeColorSettingView.Colors {
        .init(
            backgroundColor: background?.light?.color ?? .black,
            primaryColor: primary?.light?.color ?? .white,
            secondaryColor: secondary?.light?.color ?? .gray,
            textFieldForeground: textFieldForeground?.light?.color ?? .black,
            textFieldBackground: textFieldBackground?.light?.color ?? .white,
            btn1Foreground: btn1Foreground?.light?.color ?? .black,
            btn1Background: btn1Background?.light?.color ?? .white,
            btn2Foreground: btn2Foreground?.light?.color ?? .black,
            btn2Background: btn2Background?.light?.color ?? .white,
            btn3Foreground: btn3Foreground?.light?.color ?? .black,
            btn3Background: btn3Background?.light?.color ?? .black)

    }
    
}
