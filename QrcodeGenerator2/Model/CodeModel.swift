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
    /** 태그, 콤마로 구분하는 문자열 저장 */
    @Persisted var tagsValue:String = ""
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
    @Persisted var isInfavorites:Bool = false
    
    enum CodeType:Int {
        case qr = 0
        case bar = 1
    }
    
    enum InputType : Int, CaseIterable {
        case text
        case mailto
        case https
        case http
        case facebook
        case instagram
        case x
        case youtube
        case phonenumber
        case contact
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
                case .facebook:
                    return .init("facebook")
                case .instagram:
                    return .init("instagram")
                case .x:
                    return .init("x")
                case .youtube:
                    return .init("youtube")
                case .phonenumber:
                    return .init("phonenumber")
                case .contact:
                    return .init("contact")
                }
            }
        }
        
        func makeOutputString(text:String)->String {
            switch self {
            case .text:
                return text
            case .http:
                return "http://\(text)"
            case .https:
                return "https://\(text)"
            case .mailto:
                return "mailto:\(text)"
            case .facebook:
                return "facebook.com/\(text)"
            case .instagram:
                return "instagram.com/\(text)"
            case .x:
                return "x.com/\(text)"
            case .youtube:
                return "youtube.com/\(text)"
            case .phonenumber:
                return "tel:\(text)"
            case .contact:
                return text
            }
        }
    }
}

extension CodeModel {
    var tags:[TagModel] {
        var result:[TagModel] = []
        for text in tagsValue.components(separatedBy: ",") {
            let id = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if id.isEmpty == false {
                if let model = Realm.shared.object(ofType: TagModel.self, forPrimaryKey: id) {
                    result.append(model)
                }
            }
        }
        return result
    }
    
    static var favoriteCodes:Results<CodeModel> {
        Realm.shared.objects(CodeModel.self).filter("isInfavorites = %@", true).sorted(byKeyPath: "updateDtTimeIntervalSince1970", ascending: true)
    }
   
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
        inputType.makeOutputString(text: text)
    }
    var title:String {
        switch inputType {
        case .contact:
            return ContactModel.parseVCard(vCardString: text)?.fn ?? "VCARD"
        default:
            return outputString
        }
    }
    var image:Image {
        switch codeType {
        case .bar:
            return CodeGenerator.makeBarcodeImage(text: text, forground: foregroundColor, background: backgroundColor, useCache: true)
        case .qr:
            return CodeGenerator.makeQRImage(text: outputString, foreground: foregroundColor, background: backgroundColor, useCache: true)
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
    
    func togglefavorites(complete:@escaping (Error?)->Void) {
        guard let collection = FirebaseFirestoreHelper.codesCollection else {
            return
        }
        var data:[String:AnyHashable] = [
            "isInfavorites" : !isInfavorites,
            "updateDtTimeIntervalSince1970" : Date().timeIntervalSince1970
        ]
        let id = self.id
        collection.document(id).updateData(data) { error in
            if error == nil {
                data["id"] = id
                let realm = Realm.shared
                realm.beginWrite()
                realm.create(CodeModel.self, value: data, update: .modified)
                try! realm.commitWrite()
            }
            complete(error)
        }
    }
    
    static func add(codeType:CodeType , inputType:InputType, text:String, colors:(f:Color,b:Color), tags:String, complete:@escaping (_ error:Error?)->Void) {
        guard let collection = FirebaseFirestoreHelper.codesCollection else {
            return
        }
        let fci = colors.f.ciColorValue
        let bci = colors.b.ciColorValue
        let now = Date().timeIntervalSince1970
        var data:[String:AnyHashable] = [
            "text":text,
            "tagsValue":tags,
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
            "updateDtTimeIntervalSince1970":now,
        ]
        
        PointModel.use(useCase: .createCode) { error in
            guard error == nil else {
                complete(error)
                return
            }
            
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
                if data["deleted"] as? Bool == true {
                    if let obj = realm.object(ofType: CodeModel.self, forPrimaryKey: document.documentID) {
                        realm.delete(obj)
                    }
                }
                else {
                    data["id"] = document.documentID
                    realm.create(CodeModel.self, value: data, update: .all)
                }
            }
            try! realm.commitWrite()
        }
    }
    
    func delete(complete:@escaping(_ error:Error?)->Void) {
        guard let collection = FirebaseFirestoreHelper.codesCollection else {
            return
        }
        
        PointModel.use(useCase: .deleteCode) { error in
            guard error == nil else {
                complete(error)
                return
            }
            
            let id = self.id
            collection.document(id).setData([
                "deleted":true,
                "updateDtTimeIntervalSince1970":Date().timeIntervalSince1970
            ]) { error in
                guard error == nil else {
                    complete(error)
                    return
                }
                
                let realm = Realm.shared
                if let obj = realm.object(ofType: CodeModel.self, forPrimaryKey: id) {
                    realm.beginWrite()
                    realm.delete(obj)
                    try! realm.commitWrite()
                }
                complete(nil)
            }
        }
        
       
        
    }
    
    func edit(inputType:InputType, text:String, colors:(f:Color,b:Color), tags:String, complete:@escaping(_ error:Error?)->Void) {
        guard let collection = FirebaseFirestoreHelper.codesCollection else {
            return
        }
        let fci = colors.f.ciColorValue
        let bci = colors.b.ciColorValue

        var data:[String:AnyHashable] = [
            "text":text,
            "tagsValue":tags,
            "foregroundColorRed":fci.red,
            "foregroundColorGreen":fci.green,
            "foregroundColorBlue":fci.blue,
            "foregroundColorAlpha":fci.alpha,
            "backgroundColorRed":bci.red,
            "backgroundColorGreen":bci.green,
            "backgroundColorBlue":bci.blue,
            "backgroundColorAlpha":bci.alpha,
            "inputTypeValue":inputType.rawValue,
            "updateDtTimeIntervalSince1970":Date().timeIntervalSince1970
        ]
        let id = id
        
        PointModel.use(useCase: .editCode) { error in
            guard error == nil else {
                complete(error)
                return
            }
            
            collection.document(id).updateData(data) { error in
                if error == nil {
                    data["id"] = id
                    let realm = Realm.shared
                    realm.beginWrite()
                    realm.create(CodeModel.self, value: data, update: .modified)
                    try! realm.commitWrite()
                }
                complete(error)
            }

        }
        
    }
}
