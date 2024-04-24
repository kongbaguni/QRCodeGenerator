//
//  CodeImageCacheModel.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/28/23.
//

import Foundation
import RealmSwift
import SwiftUI

class CodeImageCacheModel : Object {
    @Persisted(primaryKey: true) var id:String = ""
    @Persisted var image:Data = Data()
}

extension CodeImageCacheModel {
    static func save(text:String, foreground colorA:Color, background colorB:Color, codeType:CodeModel.CodeType)->UIImage? {
        let id = "\(text) \(colorA.ciColorValue) \(colorB.ciColorValue) \(codeType.rawValue)"
        
        var image:UIImage? {
            switch codeType {
            case .qr:
                return CodeGenerator.makeQRUIImage(text: text, foreground: colorA.ciColorValue, background: colorB.ciColorValue)
            case .bar:
                return CodeGenerator.makeBarcodeUiImage(text: text, foreground: colorA.ciColorValue, background: colorB.ciColorValue)
                
            }
        }
        if let image = image?.pngData() {
            let data:[String:AnyHashable] = [
                "id":id,
                "image":image
            ]
            let realm = Realm.shared
            realm.beginWrite()
            realm.create(CodeImageCacheModel.self,value: data, update: .all)
            try! realm.commitWrite()
        }
        return image
    }
    
    static func findCachedImage(text:String, foreground colorA:Color, background colorB:Color, codeType:CodeModel.CodeType)->UIImage? {
        let id = "\(text) \(colorA.ciColorValue) \(colorB.ciColorValue) \(codeType.rawValue)"

        if let object = Realm.shared.object(ofType: CodeImageCacheModel.self, forPrimaryKey: id) {
            return .init(data: object.image)
        }
        
        return nil
    }
}


