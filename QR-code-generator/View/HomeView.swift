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
    @State var backgroundColor:Color? = .themeBackground
    @State var error:Error? = nil {
        didSet {
            if error != nil {
                isAlert = true
            }
        }
    }
    @State var isAlert:Bool = false
    @State var isSignIn = AuthManager.shared.isSignined
    @State var strongColor = Color.themeStrong
    @State var qr:String = "qr"
    @State var barcode:String = "barcode"
    
    var signin : some View {
        NavigationLink {
            SignInView()
        } label: {
            Image(systemName: "person.fill")
        }
    }
    
    var body: some View {
        List {
            Group {
                if isSignIn {
                    Section {
                        NavigationLink {
                            MakeQRCodeView(id:nil)
                        } label: {
                            HStack {
                                CodeGenerator.makeQRImage(
                                    text: qr,
                                    foreground: strongColor,
                                    background: .clear,
                                    useCache: false
                                    
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
                                    text: barcode,
                                    forground: .themeStrong,
                                    background: .clear,
                                    useCache: false
                                )
                                .resizable()
                                .scaledToFit()
                                .frame(width:100,height: 100)
                                
                                Text("make Bar codce")
                            }
                        }
                    }
                    
                    if CodeModel.favoriteCodes.count > 0 {
                        Section("favorites") {
                            FavoriteCodeListScrollView()
                        }
                    }
                    
                    if codelist.count > 0 {
                        Section("my codes") {
                            ForEach(codelist.prefix(5), id:\.self) { code in
                                NavigationLink {
                                    CodeDetailView(code: code)
                                } label: {
                                    CodeView(code: code)
                                        .frame(maxHeight: 200)
                                }
                            }
                            if codelist.count > 5 {
                                NavigationLink {
                                    CodeListView(tag:nil)
                                } label: {
                                    Text("more....")
                                }
                            }
                        }
                    }
                } else {
                    NavigationLink {
                        SignInView()
                    } label: {
                        AppTitleView()
                    }
                }
                Section("ad") {
                    NativeAdView()
                }
                .background(backgroundColor)
            }
            .listRowBackground(Color.themeBackground)
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
        .listStyle(.plain)
        .background(Color.themeBackground)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification), perform: { noti in
//            setColor()
        })
        .onReceive(NotificationCenter.default.publisher(for: .themeSettingChanged), perform: { noti in
           setColor()
        })
        .onReceive(NotificationCenter.default.publisher(for: .authDidSucessed), perform: { noti in
            do {
                let realm = Realm.shared
                realm.beginWrite()
                realm.deleteAll()
                try realm.commitWrite()
            } catch {
                self.error = error
            }
            
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
    
    func setColor() {
        DispatchQueue.main.async {
            backgroundColor = .themeBackground
            strongColor = .themeStrong
            qr = strongColor.stringValue
            barcode = strongColor.stringValue
        }
    }
}

#Preview {
    HomeView(isSignIn: true)
}
