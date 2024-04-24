//
//  QrcodeGenerator2App.swift
//  QrcodeGenerator2
//
//  Created by Changyeol Seo on 4/23/24.
//

import SwiftUI
import RealmSwift
import FirebaseCore
import GoogleMobileAds

@main
struct QrcodeGenerator2App: SwiftUI.App {
    init() {
        let _ = Realm.shared
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start { status in
            print(status)
            GoogleAdPrompt.promptWithDelay {
                
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
