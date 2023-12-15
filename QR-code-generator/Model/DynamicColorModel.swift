//
//  DynamicColorModel.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/15/23.
//

import Foundation
import SwiftUI
import RealmSwift
class DynamicColorModel : Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id:String = ""

    @Persisted var dark:ColorModel?
    @Persisted var light:ColorModel?
}

extension DynamicColorModel {
    var color:Color {
        .makeDynamicColor(light: light?.uiColor ?? .clear, dark: dark?.uiColor ?? .clear)
    }
    func makeColor(id:String,light:Color,dark:Color)->DynamicColorModel{
        let l = ColorModel.makeColor(color: light)
        let d = ColorModel.makeColor(color: dark)
        let realm = Realm.shared
        realm.beginWrite()
        let model = realm.create(DynamicColorModel.self, value: [
            "id":id,
            "dark":d,
            "light":l
        ])
        try! realm.commitWrite()
        return model
    }
}
