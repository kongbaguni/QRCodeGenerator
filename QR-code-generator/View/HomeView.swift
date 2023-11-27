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
            ascending: true)
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
                }
                Section("list") {
                    ForEach(codelist, id:\.self) { code in
                        switch code.codeType {
                        case .bar:
                            VStack {
                                code.image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight:70)
                                Text(code.text)
                            }
                        case .qr:
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
                }
            } else {
                AppTitleView()
            }
        }
        .onAppear {
            reload()
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
        }
    }
}

#Preview {
    HomeView(isSignIn: true)
}
