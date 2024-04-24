//
//  Color+Extension.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/23/23.
//

import Foundation
import SwiftUI

extension Color {
    var stringValue:String {
        let v = rgbaValue    
        return "[\(v.red):\(v.green):\(v.blue):\(v.alpha)]"
    }
    var rgbaValue:(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) {
        let uiColor = UIColor(self)
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        var alpha:CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red:red,green:green,blue:blue,alpha:alpha)
    }
    
    var ciColorValue:CIColor {
        let a = rgbaValue
        return .init(red: a.red, green: a.green, blue: a.blue, alpha: a.alpha)
    }
    
    var uiColorValue:UIColor {
        let v = rgbaValue
        return .init(red: v.red, green: v.green, blue: v.blue, alpha: v.alpha)
    }
    
    static func makeDynamicColor(light:UIColor, dark:UIColor)->Color {
        let dynamicColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return dark
            default:
                return light
            }
        }
        return Color(dynamicColor)
    }
}

extension Color {
    static var themeBackground:Color {
        ThemeManager.shared.background
    }
    static var themePrimary:Color {
        ThemeManager.shared.primary
    }
    static var themeSecondary:Color {
        ThemeManager.shared.secondary
    }
    
    static var themeStrong:Color {
        ThemeManager.shared.themeModel?.strong?.color ?? .teal
    }

    static var themeTextfieldForground:Color {
        ThemeManager.shared.themeModel?.textFieldForeground?.color ?? .primary
    }
    
    static var themeTextFieldBackground:Color {
        ThemeManager.shared.themeModel?.textFieldBackground?.color ?? .clear
    }
    
    static var themeBtn1Foreground:Color {
        ThemeManager.shared.btn1Foreground
    }
    
    static var themeBtn1Background:Color {
        ThemeManager.shared.btn1Background
    }

    static var themeBtn2Foreground:Color {
        ThemeManager.shared.btn2Foreground
    }
    
    static var themeBtn2Background:Color {
        ThemeManager.shared.btn2Background
    }

    static var themeBtn3Foreground:Color {
        ThemeManager.shared.btn3Foreground
    }
    
    static var themeBtn3Background:Color {
        ThemeManager.shared.btn3Background
    }
    
}
