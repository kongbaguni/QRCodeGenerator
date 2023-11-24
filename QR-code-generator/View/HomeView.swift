//
//  HomeView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/24/23.
//

import SwiftUI

struct HomeView: View {
    var signin : some View {
        NavigationLink {
            SignInView()
        } label: {
            Text("Signin")
        }
    }
    
    var body: some View {
        ScrollView {
            AppTitleView()
            signin
        }
        .toolbar {
            signin
        }
        .navigationTitle(Text("Home"))
        
    }
}

#Preview {
    HomeView()
}
