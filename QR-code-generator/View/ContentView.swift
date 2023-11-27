//
//  ContentView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/23/23.
//

import SwiftUI

struct ContentView: View {
    @State var navigationPath = NavigationPath()
    var body: some View {
        NavigationView {
            NavigationStack(path: $navigationPath, root: {
               HomeView()
            })
        }
        .navigationViewStyle(.stack)
        
    }
}

#Preview {
    ContentView()
}
