//
//  Color+Extension.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/23/23.
//

import Foundation
import SwiftUI

extension Color {
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
}
