//
//  FirestoreHelper.swift
//  LivePixel
//
//  Created by Changyeol Seo on 2023/08/24.
//

import Foundation
import FirebaseFirestore
import RealmSwift
import SwiftUI

struct FirebaseFirestoreHelper {    
    static var pointCollection:CollectionReference? {
        guard let userid = AuthManager.shared.userId else {
            return nil
        }
        return Firestore.firestore().collection(userid).document("data").collection("point")
    }
    
    static var codesCollection:CollectionReference? {
        guard let userid = AuthManager.shared.userId else {
            return nil
        }
        return Firestore.firestore().collection(userid).document("data").collection("codes")
    }

}
