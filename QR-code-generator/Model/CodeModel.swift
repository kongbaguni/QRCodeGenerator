//
//  CodeModel.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/24/23.
//

import Foundation
import RealmSwift
import SwiftUI
class CodeModel : Object , ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id:String = ""
    @Persisted var text:String = ""
    
    @Persisted var foregroundColorRed:Double = 0
    @Persisted var foregroundColorGreen:Double = 0
    @Persisted var foregroundColorBlue:Double = 0
    @Persisted var foregroundColorAlpha:Double = 0

    @Persisted var backgroundColorRed:Double = 0
    @Persisted var backgroundColorGreen:Double = 0
    @Persisted var backgroundColorBlue:Double = 0
    @Persisted var backgroundColorAlpha:Double = 0
    
    @Persisted var codeTypeValue:Int = 0
    
    @Persisted var regDtTimeIntervalSince1970:Double = Date().timeIntervalSince1970
    @Persisted var updateDtTimeIntervalSince1970:Double = Date().timeIntervalSince1970
    
    enum CodeType:Int {
        case qr = 0
        case bar = 1
    }
}

extension CodeModel {
    var regDt:Date {
        .init(timeIntervalSince1970: regDtTimeIntervalSince1970)
    }
    
    var updateDt:Date {
        .init(timeIntervalSince1970: updateDtTimeIntervalSince1970)
    }
    
    var codeType:CodeType {
        .init(rawValue: codeTypeValue) ?? .qr
    }
    
    var foregroundColor:Color {
        .init(red: foregroundColorRed, green: foregroundColorGreen, blue: foregroundColorBlue, opacity: foregroundColorAlpha)
    }
    
    var backgroundColor:Color {
        .init(red: backgroundColorRed, green: backgroundColorGreen, blue: backgroundColorBlue, opacity: backgroundColorAlpha)
    }
}
