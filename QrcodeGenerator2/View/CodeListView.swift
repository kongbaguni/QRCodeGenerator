//
//  CodeListView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/29/23.
//

import SwiftUI
import RealmSwift

struct CodeListView: View {
    let tag:String?

    @ObservedResults (
        CodeModel.self,
        sortDescriptor: .init(
            keyPath: "updateDtTimeIntervalSince1970",
            ascending: false)
        
    ) var codelist
    
    var body: some View {
        List {
            Group {
                ForEach(codelist, id:\.self) { code in
                    NavigationLink {
                        CodeDetailView(code: code)
                    }label: {
                        CodeView(code: code)
                            .frame(maxHeight: 200)
                    }
                }
                Section("ad") {
                    NativeAdView()
                }
            }.listRowBackground(Color.themeBackground)
        }
        .listStyle(.plain)
        .background(Color.themeBackground)
        .navigationTitle(.init(tag ?? "code list"))
        .onAppear {
            if let tag = tag {
                $codelist.filter = .init(format: "tagsValue contains %@", tag)
            }
        }
    }
}

#Preview {
    CodeListView(tag: "123")
}
