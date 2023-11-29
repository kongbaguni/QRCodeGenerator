//
//  HomeView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/24/23.
//

import SwiftUI
import RealmSwift

struct HomeView: View {
    @ObservedResults (
        CodeModel.self,
        sortDescriptor: .init(
            keyPath: "updateDtTimeIntervalSince1970",
            ascending: false)
    ) var codelist
    @State var error:Error? = nil {
        didSet {
            if error != nil {
                isAlert = true
            }
        }
    }
    @State var isAlert:Bool = false
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
                Section {
                    NavigationLink {
                        MakeQRCodeView(id:nil)
                    } label: {
                        HStack {
                            CodeGenerator.makeQRImage(
                                text: "QR",
                                foreground: .teal,
                                background: .clear,
                                useCache: true
                                                      
                            )
                                .resizable()
                                .scaledToFit()
                                .padding(20)
                                .frame(width:100,height: 100)
                            Text("make QR code")
                            
                        }
                    }
                    
                    NavigationLink {
                        MakeBarCodeView(id:nil)
                    } label : {
                        HStack {
                            CodeGenerator.makeBarcodeImage(
                                text: "barcode", 
                                forground: .teal,
                                background: .clear,
                                useCache: true
                            )
                                .resizable()
                                .scaledToFit()
                                .frame(width:100,height: 100)
                            
                            Text("make Bar codce")
                        }
                    }
                }
                Section("my codes") {
                    ForEach(codelist.prefix(5), id:\.self) { code in
                        NavigationLink {
                            CodeDetailView(code: code)
                        } label: {
                            HStack {
                                code.image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height:100)
                                Text(code.outputString)
                                Spacer()
                            }
                        }
                    }
                    NavigationLink {
                        CodeListView(tag:nil)
                    } label: {
                        Text("more....")
                    }
                }
            } else {
                AppTitleView()
            }
        }
        .onAppear {
            reload()
            PointModel.initPoint { error in
                self.error = error
            }
        }
        .refreshable {
            reload()
        }
        .toolbar {
            signin
        }
        .onReceive(NotificationCenter.default.publisher(for: .authDidSucessed), perform: { noti in
            isSignIn = AuthManager.shared.isSignined
        })
        .navigationTitle(Text("Home"))
        
    }
    
    func reload() {
        CodeModel.sync { error in
            self.error = error
            TagModel.sync { error in
                self.error = error
            }
        }
    }
}

#Preview {
    HomeView(isSignIn: true)
}
