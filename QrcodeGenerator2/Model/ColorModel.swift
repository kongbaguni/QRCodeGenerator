//
//  ColorModel.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/15/23.
//

import Foundation
import RealmSwift
import SwiftUI

class ColorModel : Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id:String = ""
    @Persisted var red:Double = 0.0
    @Persisted var green:Double = 0.0
    @Persisted var blue:Double = 0.0
    @Persisted var alpha:Double = 0.0
}

extension ColorModel {
    var color:Color {
        .init(red: red, green: green, blue: blue, opacity: alpha)
    }
    
    var uiColor:UIColor {
        .init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static func makeColor(light:Color, dark:Color)->ColorModel {
        makeColor(color: .makeDynamicColor(light: light.uiColorValue, dark: dark.uiColorValue))
    }
    
    static func makeColor(color:Color)->ColorModel {
        let v = color.rgbaValue
        
        let realm = Realm.shared
        realm.beginWrite()
        let result = realm.create(ColorModel.self, value: [
            "id":"\(v.red):\(v.green):\(v.blue):\(v.alpha)",
            "red":v.red,
            "green":v.green,
            "blue":v.blue,
            "alpha":v.alpha
        ], update: .all)
        try! realm.commitWrite()
        return result
    }
}
