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
    @Persisted var strong:DynamicColorModel?
    
    @Persisted var textFieldBackground:DynamicColorModel?
    @Persisted var textFieldForeground:DynamicColorModel?
    
    @Persisted var btn1Background:DynamicColorModel?
    @Persisted var btn1Foreground:DynamicColorModel?
    @Persisted var btn2Background:DynamicColorModel?
    @Persisted var btn2Foreground:DynamicColorModel?
    @Persisted var btn3Background:DynamicColorModel?
    @Persisted var btn3Foreground:DynamicColorModel?
    
    @Persisted var regDateTimeIntervalSince1970:Double = Date().timeIntervalSince1970
    @Persisted var updateDateTmeIntervalSince1970:Double = Date().timeIntervalSince1970
}

extension ThemeModel {
    static func create(id:String?, title:String, dark:ThemeColorSettingView.Colors, light:ThemeColorSettingView.Colors, complete:@escaping(_ error : Error?,_ id:String?)->Void) {
        let value:[String:AnyHashable] = [
            "id" : id ?? "\(UUID().uuidString):\(Date().timeIntervalSince1970)",
            "title" : title,
            "background" : DynamicColorModel.makeColor(light: light.backgroundColor, dark: dark.backgroundColor),
            "primary" : DynamicColorModel.makeColor(light: light.primaryColor, dark: dark.primaryColor),
            "secondary" : DynamicColorModel.makeColor(light: light.secondaryColor, dark: dark.secondaryColor),
            "strong" : DynamicColorModel.makeColor(light: light.strong, dark: dark.strong),
            "textFieldBackground" : DynamicColorModel.makeColor(light: light.textFieldBackground, dark: dark.textFieldBackground),
            "textFieldForeground" : DynamicColorModel.makeColor(light: light.textFieldForeground, dark: dark.textFieldForeground),
            "btn1Background" : DynamicColorModel.makeColor(light: light.btn1Background, dark: dark.btn1Background),
            "btn1Foreground" : DynamicColorModel.makeColor(light: light.btn1Foreground, dark: dark.btn1Foreground),
            "btn2Background" : DynamicColorModel.makeColor(light: light.btn2Background, dark: dark.btn2Background),
            "btn2Foreground" : DynamicColorModel.makeColor(light: light.btn2Foreground, dark: dark.btn2Foreground),
            "btn3Background" : DynamicColorModel.makeColor(light: light.btn3Background, dark: dark.btn3Background),
            "btn3Foreground" : DynamicColorModel.makeColor(light: light.btn3Foreground, dark: dark.btn3Foreground),
            "regDateTimeIntervalSince1970" : Date().timeIntervalSince1970,
            "updateDateTmeIntervalSince1970" : Date().timeIntervalSince1970
        ]
        
        let realm = Realm.shared
        realm.beginWrite()
        let model = realm.create(ThemeModel.self, value: value, update: .all)
        try! realm.commitWrite()
        
        print(model.stringValue ?? "없다")
        if let string = model.stringValue {
            let json:[String:AnyHashable] = [
                "data" : string,
                "updateDateTmeIntervalSince1970" : model.updateDateTmeIntervalSince1970
            ]
            FirebaseFirestoreHelper.themeCollection?.document(model.id)
                .setData(json) { error in
                    complete(error, model.id)
            }
        }
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
            btn3Background: btn3Background?.dark?.color ?? .black,
            strong :strong?.dark?.color ?? .yellow
        )
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
            btn3Background: btn3Background?.light?.color ?? .black,
            strong :strong?.dark?.color ?? .teal
        )

    }
    
    
    static func sync(complete:@escaping(Error?)->Void) {
        guard let collection = FirebaseFirestoreHelper.themeCollection else {
            return
        }
        let lastDt = Realm.shared.objects(ThemeModel.self).sorted(byKeyPath: "updateDateTmeIntervalSince1970", ascending: true).last?.updateDateTmeIntervalSince1970 ?? 0
        collection.whereField("updateDateTmeIntervalSince1970", isGreaterThan: lastDt).getDocuments { snapshot, error in
            for document in snapshot?.documents ?? [] {
                let data = document.data()
                print(data)
                if let string = data["data"] as? String,
                    let dic = string.dictionaryValue {
                    do {
                        let realm = Realm.shared
                        realm.beginWrite()
                        realm.create(ThemeModel.self, value: dic, update: .all)
                        try realm.commitWrite()
                        
                    } catch {
                        print(error)
                    }
                }
            }
            complete(error)
        }
        
    }
}
