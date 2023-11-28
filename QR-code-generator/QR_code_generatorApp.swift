//
//  QR_code_generatorApp.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/23/23.
//

import SwiftUI
import RealmSwift
import FirebaseCore

@main
struct QR_code_generatorApp: SwiftUI.App {
    init() {
        let _ = Realm.shared
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
