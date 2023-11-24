//
//  HomeView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/24/23.
//

import SwiftUI

struct HomeView: View {
    @State var isSignIn = AuthManager.shared.isSignined
    
    var signin : some View {
        NavigationLink {
            SignInView()
        } label: {
            Image(systemName: "person.fill")
        }
    }
    
    var body: some View {
        ScrollView {
            if isSignIn {
                
            } else {
                AppTitleView()
            }
        }
        .toolbar {
            signin
        }
        .onReceive(NotificationCenter.default.publisher(for: .authDidSucessed), perform: { noti in
            isSignIn = AuthManager.shared.isSignined
        })
        .navigationTitle(Text("Home"))
        
    }
}

#Preview {
    HomeView()
}
