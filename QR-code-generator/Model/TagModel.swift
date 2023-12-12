//
//  TagModel.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/27/23.
//

import Foundation
import RealmSwift
class TagModel : Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var text:String = ""
    @Persisted var regDtTimeIntervalSince1970:Double = Date().timeIntervalSince1970
    @Persisted var regUserId:String = ""
}

extension TagModel {
    var isMyTag:Bool {
        AuthManager.shared.userId == regUserId
    }
    
    var regDt:Date {
        .init(timeIntervalSince1970: regDtTimeIntervalSince1970)
    }
    
    static var tags:[String] {
        Realm.shared.objects(TagModel.self).sorted(byKeyPath: "text", ascending: true).map { model in
            model.text
        }
    }
    
    /** 테그목록 */
    static func sync(complete:@escaping(_ error:Error?)->Void) {
        guard let collection = FirebaseFirestoreHelper.tagsCollection else {
            return
        }
        let lasttime = Realm.shared.objects(TagModel.self).sorted(byKeyPath: "regDtTimeIntervalSince1970", ascending: true).last?.regDtTimeIntervalSince1970 ?? 0
        
        collection.whereField("regDtTimeIntervalSince1970", isGreaterThan: lasttime)
            .getDocuments { snapShot, error in
                let realm = Realm.shared
                realm.beginWrite()
                for document in snapShot?.documents ?? [] {
                    let data = document.data()
                    realm.create(TagModel.self, value: data, update: .all)                    
                }
                try! realm.commitWrite()
                complete(error)
            }
    }
    
    /** 신규 태그 추가*/
    static func addNewTag(text:String, complete:@escaping(_ error:Error?)->Void) {
        guard let userId = AuthManager.shared.userId,
              let collection = FirebaseFirestoreHelper.tagsCollection else {
            return
        }
        
        let tag = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard tag.isEmpty == false else {
            return
        }
        
        let data:[String:AnyHashable] = [
            "text":tag,
            "regDtTimeIntervalSince1970":Date().timeIntervalSince1970,
            "regUserId":userId
        ]
    
        sync { error in
            if Realm.shared.objects(TagModel.self).filter("text = %@",text).count == 0 {
                collection.document(tag).setData(data) { error in
                    complete(error)
                    let realm = Realm.shared
                    realm.beginWrite()
                    realm.create(TagModel.self, value: data, update: .all)
                    try! realm.commitWrite()
                }
            } else {
                complete(CustomError.tagsAlreadyRegistered)
            }
        }
    }
    
    /** 콤마로 구분하는 문자열의 태그 추가하기*/
    static func addNewTags(text:String, progress:@escaping(_ progress:Progress)->Void,complete:@escaping(_ error:Error?)->Void) {
        let arr = text.components(separatedBy: ",")
        let total = arr.count
        let prog = Progress()
        prog.totalUnitCount = Int64(total)
        
        for str in arr {
            let tag = str.trimmingCharacters(in: .whitespacesAndNewlines)
            if tag.isEmpty {
                prog.completedUnitCount += 1
                progress(prog)
                continue
            }
            addNewTag(text: tag) { error in
                prog.completedUnitCount += 1
                progress(prog)
                if prog.completedUnitCount == prog.completedUnitCount {
                    complete(error)
                }
            }
        }
    }
}
