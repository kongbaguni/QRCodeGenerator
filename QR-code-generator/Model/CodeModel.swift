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
    @Persisted var inputTypeValue:Int = 0
    
    @Persisted var regDtTimeIntervalSince1970:Double = Date().timeIntervalSince1970
    @Persisted var updateDtTimeIntervalSince1970:Double = Date().timeIntervalSince1970
    
    enum CodeType:Int {
        case qr = 0
        case bar = 1
    }
    
    enum InputType : Int, CaseIterable {
        case text
        case mailto
        case https
        case http
        static var allTexts:[Text] {
            return InputType.allCases.map { type in
                switch type {
                case .text:
                    return .init("text")
                case .mailto:
                    return .init("mailto")
                case .https:
                    return .init("https")
                case .http:
                    return .init("http")
                }
            }
        }
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
    
    var inputType:InputType {
        .init(rawValue: inputTypeValue) ?? .text
    }
    
    var foregroundColor:Color {
        .init(red: foregroundColorRed, green: foregroundColorGreen, blue: foregroundColorBlue, opacity: foregroundColorAlpha)
    }
    
    var backgroundColor:Color {
        .init(red: backgroundColorRed, green: backgroundColorGreen, blue: backgroundColorBlue, opacity: backgroundColorAlpha)
    }
    var outputString:String {
        switch inputType {
        case .text:
            return text
        case .http:
            return "http://\(text)"
        case .https:
            return "https://\(text)"
        case .mailto:
            return "mailto:\(text)"
        }
    }
    
    var image:Image {
        switch codeType {
        case .bar:
            return CodeGenerator.makeBarcodeImage(text: text, forground: foregroundColor, background: backgroundColor)
        case .qr:
            return CodeGenerator.makeQRImage(text: outputString, foreground: foregroundColor, background: backgroundColor)
        }
    }
    
    var uiimage:UIImage? {
        switch codeType {
        case .bar:
            return CodeGenerator.makeBarcodeUiImage(text: text, foreground: foregroundColor.ciColorValue, background: backgroundColor.ciColorValue)
        case .qr:
            return CodeGenerator.makeQRUIImage(text: outputString, foreground: foregroundColor.ciColorValue, background: backgroundColor.ciColorValue)
        }

    }
}


extension CodeModel {
    static var lastAddedDocumentId:String? = nil
    static func add(codeType:CodeType , inputType:InputType, text:String,colors:(f:Color,b:Color), complete:@escaping (_ error:Error?)->Void) {
        guard let collection = FirebaseFirestoreHelper.codesCollection else {
            return
        }
        let fci = colors.f.ciColorValue
        let bci = colors.b.ciColorValue
        let now = Date().timeIntervalSince1970
        var data:[String:AnyHashable] = [
            "text":text,
            "inputTypeValue":inputType.rawValue,
            "foregroundColorRed":fci.red,
            "foregroundColorGreen":fci.green,
            "foregroundColorBlue":fci.blue,
            "foregroundColorAlpha":fci.alpha,
            "backgroundColorRed":bci.red,
            "backgroundColorGreen":bci.green,
            "backgroundColorBlue":bci.blue,
            "backgroundColorAlpha":bci.alpha,
            "codeTypeValue":codeType.rawValue,
            "regDtTimeIntervalSince1970":now,
            "updateDtTimeIntervalSince1970":now
        ]
        
        let document = collection.addDocument(data: data) { error in
            if error == nil {
                if let id = lastAddedDocumentId {
                    data["id"] = id
                }
                let realm = Realm.shared
                realm.beginWrite()
                realm.create(CodeModel.self, value: data, update: .all)
                try! realm.commitWrite()
            }
            complete(error)
        }
        
        lastAddedDocumentId = document.documentID
        
    }
    
    static func sync(complete:@escaping(_ error:Error?)->Void) {
        guard let collection = FirebaseFirestoreHelper.codesCollection else {
            return
        }
        let lastUpdateDt = Realm.shared.objects(CodeModel.self).sorted(byKeyPath: "updateDtTimeIntervalSince1970", ascending: true).last?.updateDtTimeIntervalSince1970 ?? 0
        let query = collection.whereField("updateDtTimeIntervalSince1970", isGreaterThan: lastUpdateDt)
        
        query.getDocuments { snapShot, error in
            let realm = Realm.shared
            realm.beginWrite()
            print("sync newcount : \(snapShot?.documents.count ?? 0)")
            for document in snapShot?.documents ?? [] {
                var data = document.data()
                data["id"] = document.documentID
                realm.create(CodeModel.self, value: data, update: .all)
            }
            try! realm.commitWrite()
        }
        
    }
}
