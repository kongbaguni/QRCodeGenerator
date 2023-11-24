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
        List {
            if isSignIn {
                NavigationLink {
                    MakeQRCodeView()
                } label: {
                    HStack {
                        CodeGenerator.makeQRImage(text: "QR", foreground: .teal, background: .clear)
                            .resizable()
                            .scaledToFit()
                            .padding(20)
                            .frame(width:100,height: 100)
                        Text("make QR code")
                        
                    }
                }
                
                NavigationLink {
                    MakeBarCodeView()
                } label : {
                    HStack {
                        CodeGenerator.makeBarcodeImage(text: "barcode", forground: .teal, background: .clear)
                            .resizable()
                            .scaledToFit()
                            .frame(width:100,height: 100)
                        
                        Text("make Bar codce")
                    }
                }
                
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
    HomeView(isSignIn: true)
}
